// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import Foundation
import PackageDescription

let package = Package(
    name: "BudgetBookPackage",
    defaultLocalization: "ja",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.19.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .composableArchitecture,
                "HomeFeature"
            ],
//            plugins: [
//                .swiftLint()
//            ]
        ),
        .target(
            name: "CommonFeature",
//            plugins: [
//                .swiftLint()
//            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                .composableArchitecture,
                "CommonFeature",
                "SharedModel",
            ],
//            plugins: [
//                .swiftLint()
//            ]
        ),
        .target(
            name: "Resources",
//            plugins: [
//                .swiftLint()
//            ]
        ),
        .target(
            name: "SharedModel",
//            plugins: [
//                .swiftLint()
//            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"],
//            plugins: [
//                .swiftLint()
//            ]
        ),
    ],
)

extension Target.Dependency {
    static let composableArchitecture: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}
for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(.enableUpcomingFeature("InferSendableFromCaptures"))
}

extension Target.PluginUsage {
    static func swiftLint() -> Self {
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
    }
}

//var swiftLintPlugins: [Target.PluginUsage] {
//   guard Environment.enableSwiftLint else { return [] }
//   return [
//       .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
//   ]
//}
//
//enum Environment {
//   static func get(_ key: String) -> String? {
//       ProcessInfo.processInfo.environment[key]
//   }
//   static var enableSwiftLint: Bool {
//       Self.get("SWIFTLINT") == "true"
//   }
//}
