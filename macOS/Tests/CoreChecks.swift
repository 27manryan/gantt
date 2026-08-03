import AdaptiveStudyBoardCore
import Foundation

@main
enum CoreChecks {
    static func main() {
        checkCalendar()
        checkCompletionReflow()
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
            from: "2026-04-13",
            through: "2026-04-19",
            configuration: .apr2026
        )
        require(days.map(\.date) == ["2026-04-13", "2026-04-14", "2026-04-15", "2026-04-16", "2026-04-17"], "calendar dates")
        require(days.map(\.capacity) == [2, 2, 2, 2, 1], "capacity exception")
    }

    private static func checkCompletionReflow() {
        let assignments = [
            StudyAssignment(id: "a", course: .bama, title: "First", earliest: "2026-04-13", due: "2026-04-20"),
            StudyAssignment(id: "b", course: .bama, title: "Second", earliest: "2026-04-13", due: "2026-04-20"),
            StudyAssignment(id: "c", course: .bama, title: "Third", earliest: "2026-04-13", due: "2026-04-20"),
        ]
        let plan = StudyPlanner.makePlan(
            assignments: assignments,
            progress: ProgressSnapshot(completedIDs: ["a"], planFrom: "2026-04-13")
        )
        require(plan.days.first?.blocks.map { $0.assignment.id } == ["b", "c"], "completion reflow")
        require(plan.unscheduled.isEmpty, "available capacity")
    }

    private static func checkConstraints() {
        let assignments = [
            StudyAssignment(id: "a", course: .baba, title: "A", earliest: "2026-04-13", due: "2026-04-14"),
            StudyAssignment(id: "b", course: .balm, title: "B", earliest: "2026-04-13", due: "2026-04-14"),
        ]
        let configuration = PlannerConfiguration(
            start: "2026-04-13",
            end: "2026-04-16",
            excludedDates: ["2026-04-15"],
            incompatibleCourses: [.baba: [.balm], .balm: [.baba]]
        )
        let plan = StudyPlanner.makePlan(
            assignments: assignments,
            progress: ProgressSnapshot(planFrom: "2026-04-14"),
            configuration: configuration
        )
        require(plan.days.map(\.date) == ["2026-04-14", "2026-04-16"], "exclusion and conflict")
        require(plan.late.map { $0.assignment.id } == ["b"], "deadline warning")
    }

    private static func checkProgressRoundTrip() {
        let suite = "AdaptiveStudyBoardChecks-\(UUID().uuidString)"
        defer { UserDefaults.standard.removePersistentDomain(forName: suite) }
        let repository = ProgressRepository(suiteName: suite)
        let expected = ProgressSnapshot(completedIDs: ["one", "two"], planFrom: "2026-05-01")
        repository.save(expected)
        require(repository.load() == expected, "progress round trip")
    }
}
