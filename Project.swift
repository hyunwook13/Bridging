import ProjectDescription

let plistOverrides: [String: Plist.Value] = [
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

let project = Project(
    name: "Bridging",
    targets: [
        .target(
            name: "Bridging",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Wook.Bridging",
            infoPlist: .extendingDefault(with: plistOverrides),
            sources: ["Project/Sources/**"],
            resources: ["Project/Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "GoogleSignIn"),
                .external(name: "Supabase"),
            ]
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
)vi
