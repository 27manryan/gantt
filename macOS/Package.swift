// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "AdaptiveStudyBoardCore",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "AdaptiveStudyBoardCore", targets: ["AdaptiveStudyBoardCore"]),
        .executable(name: "CoreChecks", targets: ["CoreChecks"]),
    ],
    targets: [
        .target(name: "AdaptiveStudyBoardCore", path: "Shared"),
        .executableTarget(
            name: "CoreChecks",
            dependencies: ["AdaptiveStudyBoardCore"],
            path: "Tests"
        ),
    ]
)
