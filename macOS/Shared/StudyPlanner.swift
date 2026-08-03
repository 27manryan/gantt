import Foundation

public struct PlannerConfiguration: Sendable {
    public let start: String
    public let end: String
    public let excludedDates: Set<String>
    public let capacityByDate: [String: Int]
    public let incompatibleCourses: [CourseID: Set<CourseID>]

    public init(
        start: String,
        end: String,
        excludedDates: Set<String> = [],
        capacityByDate: [String: Int] = [:],
        incompatibleCourses: [CourseID: Set<CourseID>] = [:]
    ) {
        self.start = start
        self.end = end
        self.excludedDates = excludedDates
        self.capacityByDate = capacityByDate
        self.incompatibleCourses = incompatibleCourses
    }

    public static let apr2026 = PlannerConfiguration(
        start: "2026-04-13",
        end: "2026-06-26",
        excludedDates: ["2026-05-25"],
        capacityByDate: ["2026-04-17": 1],
        incompatibleCourses: [.baba: [.balm], .balm: [.baba]]
    )
}

public enum StudyDate {
    public static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

    public static func parse(_ value: String) -> Date {
        let parts = value.split(separator: "-").compactMap { Int($0) }
        precondition(parts.count == 3, "Invalid ISO date: \(value)")
        return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))!
    }

    public static func iso(_ date: Date) -> String {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year!, parts.month!, parts.day!)
    }

    public static func addDays(_ value: String, _ amount: Int) -> String {
        iso(calendar.date(byAdding: .day, value: amount, to: parse(value))!)
    }

    public static func weekday(_ value: String) -> Int {
        calendar.component(.weekday, from: parse(value))
    }
}

public enum StudyPlanner {
    private struct WorkDay: Sendable {
        let date: String
        let capacity: Int
    }

    public static func workDays(
        from start: String,
        through end: String,
        configuration: PlannerConfiguration
    ) -> [(date: String, capacity: Int)] {
        var result: [(String, Int)] = []
        var cursor = start

        while cursor <= end {
            let weekday = StudyDate.weekday(cursor)
            if weekday != 1, weekday != 7, !configuration.excludedDates.contains(cursor) {
                let capacity = max(0, configuration.capacityByDate[cursor] ?? 2)
                if capacity > 0 { result.append((cursor, capacity)) }
            }
            cursor = StudyDate.addDays(cursor, 1)
        }

        return result
    }

    public static func makePlan(
        assignments: [StudyAssignment],
        progress: ProgressSnapshot,
        configuration: PlannerConfiguration = .apr2026
    ) -> StudyPlan {
        let workDays = workDays(from: progress.planFrom, through: configuration.end, configuration: configuration)
            .map { WorkDay(date: $0.date, capacity: $0.capacity) }
        var scheduledByDate: [String: [PlannedBlock]] = [:]
        var unscheduled: [PlannedBlock] = []

        for assignment in assignments where !progress.completedIDs.contains(assignment.id) {
            for blockNumber in 1...assignment.blocks {
                let earliest = max(progress.planFrom, assignment.earliest)
                guard let day = workDays.first(where: { day in
                    guard day.date >= earliest else { return false }
                    let existing = scheduledByDate[day.date, default: []]
                    guard existing.count < day.capacity else { return false }
                    let blocked = configuration.incompatibleCourses[assignment.course, default: []]
                    return existing.allSatisfy { !blocked.contains($0.assignment.course) }
                }) else {
                    unscheduled.append(
                        PlannedBlock(
                            assignment: assignment,
                            scheduledDate: configuration.end,
                            block: blockNumber,
                            blockCount: assignment.blocks
                        )
                    )
                    continue
                }

                scheduledByDate[day.date, default: []].append(
                    PlannedBlock(
                        assignment: assignment,
                        scheduledDate: day.date,
                        block: blockNumber,
                        blockCount: assignment.blocks
                    )
                )
            }
        }

        let days = scheduledByDate.keys.sorted().map { date in
            PlanDay(date: date, blocks: scheduledByDate[date, default: []])
        }
        let late = days.flatMap(\.blocks).filter { $0.scheduledDate > $0.assignment.due }
        return StudyPlan(days: days, unscheduled: unscheduled, late: late)
    }
}
