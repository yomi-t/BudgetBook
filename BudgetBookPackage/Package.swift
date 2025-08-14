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
            targets: ["AppFeature"])
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
                "HomeFeature"
            ]
        ),
        .target(
            name: "AddFeature",
            dependencies: [
                .composableArchitecture,
                "Components",
                "Extensions",
                "SharedModel",
                "Repository"
            ]
        ),
        .target(
            name: "Components"
        ),
        .target(
            name: "Extensions",
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                .composableArchitecture,
                "Repository",
                "SharedModel"
            ]
        ),
        .target(
            name: "Protocols",
            dependencies: [
                "SharedModel"
            ]
        ),
        .target(
            name: "Repository",
            dependencies: [
                "Protocols",
                "SharedModel"
            ]
        ),
        .target(
            name: "Resources",
            resources: [
                .process("Assets.xcassets")
            ]
        ),
        .target(
            name: "SharedModel"
        ),
        .testTarget(
            name: "AddFeatureTests",
            dependencies: [
                .composableArchitecture,
                "AddFeature",
                "SharedModel",
                .swiftTesting
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
                "SharedModel",
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
