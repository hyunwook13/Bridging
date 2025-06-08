import ProjectDescription

let project = Project(
    name: "Tests",
    targets: [
        .target(
            name: "BridgingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.Wook.BridgingTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default, // 필요 시 .extendingDefault(with:)로 변경 가능
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Feature", path: "../Feature"),
            ]
        )
    ]
)

