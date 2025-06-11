import ProjectDescription
import ProjectDescriptionHelpers

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
                .project(target: "CommonUI", path: "../../CommonUI"),
                .external(name: "PinLayout"),
                .external(name: "SkeletonView"),
            ]
        ),

        // 추가된 CommentsDemo 앱 타겟
        .target(
            name: "FeatureOnBoardingApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureOnBoardingApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "FeatureOnBoardingApp.SceneDelegate"
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
                .target(name: "FeatureOnBoarding"),
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

