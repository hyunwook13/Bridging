import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
//        .t
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "Feature",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "com.Wook.feature",
            deploymentTargets: .iOS("16.0"),
//            infoPlist: .default,
            resources: [],
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

//// Features/Project.swift
//import ProjectDescription
//
//let project = Project(
//  name: "Features",
//  targets: [
//    .aggregate(
//      name: "Features",
//      platform: .iOS,
//      product: .staticLibrary,  // 실제 코드는 없지만, 링크니 떼려면 .none 도 가능
//      bundleId: "com.Wook.Features",
//      deploymentTargets: .iOS("16.0"),
//      infoPlist: .default,
//      dependencies: [
//        .project(target: "FeatureMain", path: "FeatureMain"),
//        .project(target: "FeatureWrite", path: "FeatureWrite"),
//        .project(target: "FeatureDetail", path: "FeatureDetail"),
//        .project(target: "FeatureComment", path: "FeatureComment"),
//        .project(target: "FeatureSearch", path: "FeatureSearch")
//      ]
//    )
//  ]
//)
