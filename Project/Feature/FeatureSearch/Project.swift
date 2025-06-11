import ProjectDescription

let project = Project(
    name: "FeatureSearch",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureSearch",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureSearch",
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
            name: "FeatureSearchApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureSearchApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FeatureSearch"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

