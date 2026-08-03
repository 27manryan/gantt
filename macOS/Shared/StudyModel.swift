import Foundation

public enum CourseID: String, Codable, CaseIterable, Hashable, Sendable {
    case baos310
    case baef210
    case baos302
    case baba
    case geo
    case ant
}

public struct CourseInfo: Identifiable, Hashable, Sendable {
    public let id: CourseID
    public let code: String
    public let name: String
    public let colorHex: String

    public init(id: CourseID, code: String, name: String, colorHex: String) {
        self.id = id
        self.code = code
        self.name = name
        self.colorHex = colorHex
    }
}

public struct StudyAssignment: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let course: CourseID
    public let title: String
    public let earliest: String
    public let due: String
    public let blocks: Int
    public let note: String?

    public init(
        id: String,
        course: CourseID,
        title: String,
        earliest: String,
        due: String,
        blocks: Int = 1,
        note: String? = nil
    ) {
        self.id = id
        self.course = course
        self.title = title
        self.earliest = earliest
        self.due = due
        self.blocks = max(1, blocks)
        self.note = note
    }
}

public struct PlannedBlock: Identifiable, Hashable, Sendable {
    public let assignment: StudyAssignment
    public let scheduledDate: String
    public let block: Int
    public let blockCount: Int

    public var id: String { "\(assignment.id)-\(block)" }

    public init(assignment: StudyAssignment, scheduledDate: String, block: Int, blockCount: Int) {
        self.assignment = assignment
        self.scheduledDate = scheduledDate
        self.block = block
        self.blockCount = blockCount
    }
}

public struct PlanDay: Identifiable, Hashable, Sendable {
    public let date: String
    public let blocks: [PlannedBlock]

    public var id: String { date }

    public init(date: String, blocks: [PlannedBlock]) {
        self.date = date
        self.blocks = blocks
    }
}

public struct StudyPlan: Sendable {
    public let days: [PlanDay]
    public let unscheduled: [PlannedBlock]
    public let late: [PlannedBlock]

    public var projectedFinish: String? { days.last?.date }
    public var nextBlocks: [PlannedBlock] { Array(days.flatMap(\.blocks).prefix(2)) }

    public init(days: [PlanDay], unscheduled: [PlannedBlock], late: [PlannedBlock]) {
        self.days = days
        self.unscheduled = unscheduled
        self.late = late
    }
}

public struct ProgressSnapshot: Codable, Equatable, Sendable {
    public var completedIDs: Set<String>
    public var planFrom: String

    public init(completedIDs: Set<String> = [], planFrom: String) {
        self.completedIDs = completedIDs
        self.planFrom = planFrom
    }
}
