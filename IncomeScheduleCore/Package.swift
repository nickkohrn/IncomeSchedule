// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "IncomeScheduleCore",
    platforms: [
        .iOS(
            .v18
        )
    ],
    products: [
        .library(
            name: "IncomeScheduleCore",
            targets: ["IncomeScheduleCore"]
        ),
        .library(
            name: "Models",
            targets: ["Models"]
        ),
        .library(
            name: "ScheduleCreationFeature",
            targets: ["ScheduleCreationFeature"]
        ),
        .library(
            name: "ScheduleFeature",
            targets: ["ScheduleFeature"]
        ),
        .library(
            name: "SharedStateExtensions",
            targets: ["SharedStateExtensions"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies.git",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "IncomeScheduleCore"
        ),
        .testTarget(
            name: "IncomeScheduleCoreTests",
            dependencies: ["IncomeScheduleCore"]
        ),
        .target(
            name: "Models"
        ),
        .target(
            name: "ScheduleCreationFeature",
            dependencies: [
                "Models",
                "SharedStateExtensions",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(
            name: "ScheduleFeature",
            dependencies: [
                "Models",
                "SharedStateExtensions",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(
            name: "SharedStateExtensions",
            dependencies: [
                "Models",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
    ]
)
