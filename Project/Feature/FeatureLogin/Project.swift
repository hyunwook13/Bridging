import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FeatureLogin",
    targets: [
        // 기존 Feature 프레임워크 타겟
        .target(
            name: "FeatureLogin",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureLogin",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            resources: [],
            dependencies: [
                .project(target: "CommonUI", path: "../../CommonUI"),
                .external(name: "PinLayout"),
                .external(name: "AppAuthCore")
            ]
        ),

        // 추가된 CommentsDemoaa앱 타겟
        .target(
            name: "FeatureLoginApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.featurae.FeatureLoginApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "FeatureLoginApp.SceneDelegate"
                                ]
                            ]
                        ]
                    ],
//                    "UILaunchScreen": [:]
                ]
            ),
            sources: ["Sources/**"],
            resources: [
              "Resources/GoogleService-Info.plist"
            ],
            dependencies: [
                .target(name: "FeatureLogin"),
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

