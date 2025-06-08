import ProjectDescription

let project = Project(
    name: "FeaturePostDetail",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeaturePostDetail",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeaturePostDetail",
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
            name: "FeaturePostDetailApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeaturePostDetailApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FeaturePostDetail"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

