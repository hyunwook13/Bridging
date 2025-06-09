import ProjectDescription

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.core",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default, // 필요 시 .extendingDefault(with:)로 변경 가능
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        )
    ]
)

