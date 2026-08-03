import Foundation

public struct ProgressRepository {
    public static let appGroup = "group.io.github.27manryan.AdaptiveStudyBoard"
    private static let storageKey = "adaptive-study-board-jul-sep-progress-v2"

    private let defaults: UserDefaults

    public init(suiteName: String = ProgressRepository.appGroup) {
        self.defaults = UserDefaults(suiteName: suiteName) ?? .standard
    }

    public func load(
        defaultPlanFrom: String = AssignmentCatalog.defaultPlanFrom(),
        defaultCompletedIDs: Set<String> = AssignmentCatalog.initialCompletedIDs
    ) -> ProgressSnapshot {
        guard
            let data = defaults.data(forKey: Self.storageKey),
            let snapshot = try? JSONDecoder().decode(ProgressSnapshot.self, from: data)
        else {
            return ProgressSnapshot(completedIDs: defaultCompletedIDs, planFrom: defaultPlanFrom)
        }
        return snapshot
    }

    public func save(_ snapshot: ProgressSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }

    public func reset() {
        defaults.removeObject(forKey: Self.storageKey)
    }
}
