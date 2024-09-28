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
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "FileManagerClient",
            targets: ["FileManagerClient"]
        ),
        .library(
            name: "PaySourcesFeature",
            targets: ["PaySourcesFeature"]
        ),
        .library(
            name: "Models",
            targets: ["Models"]
        ),
        .library(
            name: "MonthScheduleDetailsFeature",
            targets: ["MonthScheduleDetailsFeature"]
        ),
        .library(
            name: "PaySourceFormFeature",
            targets: ["PaySourceFormFeature"]
        ),
        .library(
            name: "ScheduleClient",
            targets: ["ScheduleClient"]
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
            url: "https://github.com/apple/swift-algorithms.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-tagged.git",
            from: "0.0.0"
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
            name: "DesignSystem"
        ),
        .target(
            name: "FileManagerClient",
            dependencies: [
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                ),
                .product(
                    name: "DependenciesMacros",
                    package: "swift-dependencies"
                )
            ]
        ),
        .target(
            name: "Models",
            dependencies: [
                .product(
                    name: "IdentifiedCollections",
                    package: "swift-identified-collections"
                ),
                .product(
                    name: "Tagged",
                    package: "swift-tagged"
                )
            ]
        ),
        .target(
            name: "MonthScheduleDetailsFeature",
            dependencies: [
                "DesignSystem",
                "Models",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                )
            ]
        ),
        .target(
            name: "PaySourcesFeature",
            dependencies: [
                "DesignSystem",
                "Models",
                "SharedStateExtensions",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
        .target(
            name: "PaySourceFormFeature",
            dependencies: [
                "DesignSystem",
                "Models",
                "SharedStateExtensions",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                )
            ]
        ),
        .target(
            name: "ScheduleClient",
            dependencies: [
                "Models",
                .product(
                    name: "Algorithms",
                    package: "swift-algorithms"
                ),
                .product(
                    name: "Dependencies",
                    package: "swift-dependencies"
                ),
                .product(
                    name: "DependenciesMacros",
                    package: "swift-dependencies"
                ),
                .product(
                    name: "IdentifiedCollections",
                    package: "swift-identified-collections"
                )
            ]
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
                "MonthScheduleDetailsFeature",
                "ScheduleClient",
                "ScheduleCreationFeature",
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
                "FileManagerClient",
                "Models",
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        ),
    ]
)
