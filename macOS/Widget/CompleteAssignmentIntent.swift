import AppIntents
import WidgetKit

struct CompleteAssignmentIntent: AppIntent {
    static let title: LocalizedStringResource = "Complete assignment"
    static let description = IntentDescription("Marks an assignment complete and recalculates the study plan.")

    @Parameter(title: "Assignment ID")
    var assignmentID: String

    init() {
        assignmentID = ""
    }

    init(assignmentID: String) {
        self.assignmentID = assignmentID
    }

    func perform() async throws -> some IntentResult {
        let repository = ProgressRepository()
        var progress = repository.load()
        progress.completedIDs.insert(assignmentID)
        repository.save(progress)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
