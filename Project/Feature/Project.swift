import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
//        .t
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "Feature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.feature",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            dependencies: [
                .project(target: "FeatureComments", path: "./FeatureComments"),
                .project(target: "FeatureLogin", path: "./FeatureLogin"),
                .project(target: "FeatureMain", path: "./FeatureMain"),
                .project(target: "FeatureOnBoarding", path: "./FeatureOnBoarding"),
                .project(target: "FeaturePostDetail", path: "./FeaturePostDetail"),
                .project(target: "FeaturePostCompose", path: "./FeaturePostCompose"),
                .project(target: "FeatureSearch", path: "./FeatureSearch"),
                .project(target: "FeatureSetting", path: "./FeatureSetting"),
            ]
        ),
    ]
)
