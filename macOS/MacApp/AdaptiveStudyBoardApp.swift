import SwiftUI

@main
struct AdaptiveStudyBoardApp: App {
    @StateObject private var store = BoardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .frame(minWidth: 920, minHeight: 640)
        }
        .defaultSize(width: 1120, height: 760)
        .windowStyle(.hiddenTitleBar)
    }
}
