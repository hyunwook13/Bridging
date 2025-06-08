import ProjectDescription

let project = Project(
    name: "FeatureComments",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureComments",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureComments",
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
            name: "FeatureCommentsApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureCommentsApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [
              "Resources/GoogleService-Info.plist"
            ],
            dependencies: [
                .target(name: "FeatureComments"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

