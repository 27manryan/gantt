import AdaptiveStudyBoardCore
import Foundation

@main
enum CoreChecks {
    static func main() {
        checkCalendar()
        checkCurrentCatalog()
        checkCompletionReflow()
        checkHeavyLimit()
        checkConstraints()
        checkProgressRoundTrip()
        print("All AdaptiveStudyBoard core checks passed.")
    }

    private static func require(_ condition: @autoclosure () -> Bool, _ message: String) {
        guard condition() else {
            fputs("Check failed: \(message)\n", stderr)
            exit(1)
        }
    }

    private static func checkCalendar() {
        let days = StudyPlanner.workDays(
            from: "2026-07-07",
            through: "2026-07-12",
            configuration: .jul2026
        )
        require(days.map(\.date) == ["2026-07-07", "2026-07-08", "2026-07-09", "2026-07-10", "2026-07-11"], "calendar dates including Saturday")
        require(days.map(\.capacity) == [2, 2, 2, 2, 1], "capacity exception")
    }

    private static func checkCurrentCatalog() {
        require(AssignmentCatalog.courses.count == 6, "six July subscription-period courses")
        require(AssignmentCatalog.assignments.count == 44, "current vault assignment inventory")
        require(AssignmentCatalog.initialCompletedIDs.count == 14, "vault completion defaults")

        let plan = StudyPlanner.makePlan(
            assignments: AssignmentCatalog.assignments,
            progress: ProgressSnapshot(
                completedIDs: AssignmentCatalog.initialCompletedIDs,
                planFrom: "2026-08-03"
            )
        )
        require(plan.unscheduled.isEmpty, "remaining work fits before the subscription close")
        require(plan.projectedFinish == "2026-09-23", "current workload projection")
    }

    private static func checkCompletionReflow() {
        let assignments = [
            StudyAssignment(id: "a", course: .geo, title: "First", earliest: "2026-08-03", due: "2026-08-10"),
            StudyAssignment(id: "b", course: .geo, title: "Second", earliest: "2026-08-03", due: "2026-08-10"),
            StudyAssignment(id: "c", course: .geo, title: "Third", earliest: "2026-08-03", due: "2026-08-10"),
        ]
        let plan = StudyPlanner.makePlan(
            assignments: assignments,
            progress: ProgressSnapshot(completedIDs: ["a"], planFrom: "2026-08-03")
        )
        require(plan.days.first?.blocks.map { $0.assignment.id } == ["b", "c"], "completion reflow")
        require(plan.unscheduled.isEmpty, "available capacity")
    }

    private static func checkConstraints() {
        let assignments = [
            StudyAssignment(id: "a", course: .baba, title: "A", earliest: "2026-08-03", due: "2026-08-04"),
            StudyAssignment(id: "b", course: .baos310, title: "B", earliest: "2026-08-03", due: "2026-08-04"),
        ]
        let configuration = PlannerConfiguration(
            start: "2026-08-03",
            end: "2026-08-06",
            excludedDates: ["2026-08-05"],
            incompatibleCourses: [.baba: [.baos310], .baos310: [.baba]]
        )
        let plan = StudyPlanner.makePlan(
            assignments: assignments,
            progress: ProgressSnapshot(planFrom: "2026-08-04"),
            configuration: configuration
        )
        require(plan.days.map(\.date) == ["2026-08-04", "2026-08-06"], "exclusion and conflict")
        require(plan.late.map { $0.assignment.id } == ["b"], "deadline warning")
    }

    private static func checkHeavyLimit() {
        let assignments = [
            StudyAssignment(id: "paper-a", course: .geo, title: "Paper A", earliest: "2026-08-03", due: "2026-08-10", blocks: 2),
            StudyAssignment(id: "paper-b", course: .ant, title: "Paper B", earliest: "2026-08-03", due: "2026-08-10", blocks: 2),
            StudyAssignment(id: "quiz", course: .baef210, title: "Quiz", earliest: "2026-08-03", due: "2026-08-10"),
        ]
        let plan = StudyPlanner.makePlan(
            assignments: assignments,
            progress: ProgressSnapshot(planFrom: "2026-08-03")
        )
        require(plan.days.first?.blocks.map { $0.assignment.id } == ["paper-a", "quiz"], "heavy work plus light secondary")
        require(plan.days.allSatisfy { day in day.blocks.filter { $0.assignment.blocks > 1 }.count <= 1 }, "one heavy block per day")
    }

    private static func checkProgressRoundTrip() {
        let suite = "AdaptiveStudyBoardChecks-\(UUID().uuidString)"
        defer { UserDefaults.standard.removePersistentDomain(forName: suite) }
        let repository = ProgressRepository(suiteName: suite)
        let expected = ProgressSnapshot(completedIDs: ["one", "two"], planFrom: "2026-08-03")
        repository.save(expected)
        require(repository.load() == expected, "progress round trip")
    }
}
