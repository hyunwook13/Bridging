import ProjectDescription

let project = Project(
    name: "CommonUI",
    targets: [
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.CommonUI",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default, // 필요 시 .extendingDefault(with:)로 변경 가능
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Common", path: "../Common"),
            ]
        )
    ]
)

