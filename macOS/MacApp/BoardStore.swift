import Foundation
import SwiftUI
import WidgetKit

@MainActor
final class BoardStore: ObservableObject {
    @Published private(set) var progress: ProgressSnapshot
    private let repository: ProgressRepository

    init(repository: ProgressRepository = ProgressRepository()) {
        self.repository = repository
        self.progress = repository.load()
    }

    var plan: StudyPlan {
        StudyPlanner.makePlan(assignments: AssignmentCatalog.assignments, progress: progress)
    }

    var completedCount: Int { progress.completedIDs.count }

    var remainingBlocks: Int {
        AssignmentCatalog.assignments
            .filter { !progress.completedIDs.contains($0.id) }
            .reduce(0) { $0 + $1.blocks }
    }

    var completionFraction: Double {
        Double(completedCount) / Double(AssignmentCatalog.assignments.count)
    }

    func isComplete(_ assignment: StudyAssignment) -> Bool {
        progress.completedIDs.contains(assignment.id)
    }

    func setComplete(_ assignment: StudyAssignment, complete: Bool) {
        if complete { progress.completedIDs.insert(assignment.id) }
        else { progress.completedIDs.remove(assignment.id) }
        persist()
    }

    func setPlanFrom(_ date: String) {
        guard date >= PlannerConfiguration.jul2026.start, date <= PlannerConfiguration.jul2026.end else { return }
        progress.planFrom = date
        persist()
    }

    func reset() {
        repository.reset()
        progress = ProgressSnapshot(
            completedIDs: AssignmentCatalog.initialCompletedIDs,
            planFrom: AssignmentCatalog.defaultPlanFrom()
        )
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func persist() {
        repository.save(progress)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
