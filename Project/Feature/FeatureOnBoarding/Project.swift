import ProjectDescription

let project = Project(
    name: "FeatureOnBoarding",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureOnBoarding",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureOnBoarding",
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
            name: "FeatureMainApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureOnBoardingApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "FeatureOnBoarding"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

