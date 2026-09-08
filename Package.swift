// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-rotation",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Rotation", targets: ["Rotation"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-axis.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-angle.git", branch: "main"),
    ],
    targets: [
        .target(name: "Rotation", dependencies: [
            .product(name: "Axis", package: "swift-axis"),
            .product(name: "Angle", package: "swift-angle"),
        ]),
        .testTarget(name: "Rotation Tests", dependencies: [
            .target(name: "Rotation"),
            .product(name: "Angle", package: "swift-angle"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
