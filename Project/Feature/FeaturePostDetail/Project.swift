import ProjectDescription
import ProjectDescriptionHelpers

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
                .project(target: "CommonUI", path: "../../CommonUI"),
                                .external(name: "PinLayout"),
                //                .external(name: "SkeletonView"),
            ]
        ),
        
        // 추가된 CommentsDemo 앱 타겟
        .target(
            name: "FeaturePostDetailApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeaturePostDetailApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "FeaturePostDetailApp.SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [:]
                ]
            ),
            sources: ["Sources/**"],
            resources: [
                "Resources/GoogleService-Info.plist"
            ],
            dependencies: [
                .target(name: "FeaturePostDetail"),
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

