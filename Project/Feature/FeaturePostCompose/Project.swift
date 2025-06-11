import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FeaturePostCompose",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeaturePostCompose",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeaturePostCompose",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            resources: [],
            dependencies: [
                .project(target: "CommonUI", path: "../../CommonUI"),
                .external(name: "PinLayout"),
                .external(name: "SkeletonView"),
            ]
        ),

        // 추가된 CommentsDemo 앱 타겟
        .target(
            name: "FeaturePostComposeApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeaturePostComposeApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FeaturePostCompose"),
//                .project(target: "Core", path: "../Core")
            ],
            settings: .settings(
                base: SigningHelper.mergedBaseSettings,
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release"),
                ]
            )
        )
    ]
)

