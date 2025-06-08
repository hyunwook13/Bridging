import ProjectDescription

let project = Project(
    name: "FeatureSetting",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureSetting",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureSetting",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            resources: [],
            dependencies: [
                .project(target: "Core", path: "../../Core"),
                .external(name: "GoogleSignIn"),
                .external(name: "PinLayout"),
                .external(name: "SkeletonView"),
            ]
        ),

        // 추가된 CommentsDemo 앱 타겟
        .target(
            name: "FeatureSettingApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureSettingApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FeatureSetting"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

