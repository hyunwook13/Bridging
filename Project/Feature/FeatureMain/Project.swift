import ProjectDescription

let project = Project(
    name: "FeatureMain",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureMain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureMain",
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
            bundleId: "com.Wook.feature.FeatureMainApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
//            resources: [
//              "Resources/GoogleService-Info.plist"
//            ],
            dependencies: [
                .target(name: "FeatureMain"),
//                .project(target: "Core", path: "../Core")
            ]
        )
    ]
)

