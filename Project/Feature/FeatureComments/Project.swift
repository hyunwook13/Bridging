import ProjectDescription

let project = Project(
    name: "FeatureComments",
    targets: [
        .target(
            name: "FeatureComments",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.FeatureComments",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            resources: [],
            dependencies: [
                .project(target: "CommonUI", path: "../../CommonUI"),
                .external(name: "PinLayout"),
                .external(name: "SkeletonView"),
                
            ]
        ),

        // FeatureCommentsApp 앱
        .target(
            name: "FeatureCommentsApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.feature.FeatureCommentsApp",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "FeatureCommentsApp.SceneDelegate"
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
                .target(name: "FeatureComments"),
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": ["-ObjC"]
                ]
            )
        )
    ]
)
