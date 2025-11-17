// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import Foundation
import PackageDescription

let package = Package(
    name: "BudgetBookPackage",
    defaultLocalization: "ja",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(name: "IncomeFeature",
                 targets: ["IncomeFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.19.1"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.59.1"),
        .package(url: "https://github.com/apple/swift-testing.git", from: "6.1.1")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .composableArchitecture,
                "AddFeature",
                "HomeFeature",
                "IncomeFeature"
            ]
        ),
        .target(
            name: "AddFeature",
            dependencies: [
                .composableArchitecture,
                "Core"
            ]
        ),
        .target(
            name: "Core",
            resources: [
                .process("./Resources/Assets.xcassets")
            ],
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                .composableArchitecture,
                "Core"
            ]
        ),
        .target(
            name: "IncomeFeature",
            dependencies: [
                .composableArchitecture,
                "Core",
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                .composableArchitecture,
                .swiftTesting,
                "AppFeature"
            ]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: [
                .composableArchitecture,
                "HomeFeature",
                "Core",
                .swiftTesting
            ]
        )
    ],
)

extension Target.Dependency {
    static let composableArchitecture: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let swiftTesting: Self = .product(name: "Testing", package: "swift-testing")
}
for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(.unsafeFlags(["-Xfrontend", "-disable-availability-checking"]))
    settings.append(.unsafeFlags(["-Xfrontend", "-warn-concurrency"]))
    target.swiftSettings = settings
}

extension Target.PluginUsage {
    static func swiftLint() -> Self {
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    }
}
