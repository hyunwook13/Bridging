import ProjectDescription
import ProjectDescriptionHelpers

let plistOverrides: [String: Plist.Value] = [
    "UILaunchStoryboardName": .string("LaunchScreen"),
    "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": .boolean(false),
        "UISceneConfigurations": .dictionary([
            "UIWindowSceneSessionRoleApplication": .array([
                .dictionary([
                    "UISceneConfigurationName": .string("Default Configuration"),
                    "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate"),
                    "UISceneStoryboardFile": .string("LaunchScreen")
                ])
            ])
        ])
    ])
]

import ProjectDescription

let project = Project(
    name: "Bridging",
    targets: [
        .target(
            name: "Bridging",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.Bridging",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: plistOverrides),
            sources: ["Project/Sources/**"],
            resources: ["Project/Resources/**"],
            entitlements: "Project/Entitlements/BridgingRelease.entitlements",
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "GoogleSignIn"),
                .external(name: "Supabase"),
                .external(name: "PinLayout")
            ],
            settings: .settings(base: SigningHelper.signingSettings)
        ),
        .target(
            name: "BridgingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.Wook.BridgingTests",
//            infoPlist: .default,
            sources: ["Project/BridgingTests/**"],
            resources: [],
            dependencies: [
                .target(name: "Bridging"),
                .external(name: "RxTest"),
                .external(name: "RxBlocking")
            ]
        )
    ]
)
