import ProjectDescription
import ProjectDescriptionHelpers

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
                .project(target: "CommonUI", path: "../../CommonUI"),
            ]
        ),

        // 추가된 CommentsDemo 앱 타겟
        .target(
            name: "FeatureMainApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureMainApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "FeatureMainApp.SceneDelegate"
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
                .target(name: "FeatureMain"),
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

