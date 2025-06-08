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
    ]),
    "NSPhotoLibraryUsageDescription": "앱에서 사진 보관함의 사진과 비디오를 조회 및 수정하기 위해 사용됩니다.",
    "FirebaseCrashlyticsCollectionEnabled": .boolean(true),
    "FirebaseCrashlyticsAutoSubmitEnabled": .boolean(true),
    "CFBundleURLTypes": .array([
        .dictionary([
            "CFBundleTypeRole": .string("Editor"),
            "CFBundleURLName": .string("google_login_call_back"),
            "CFBundleURLSchemes": .array([
                .string("com.googleusercontent.apps.56373788373-bs996t6ri7h8rij4jv9g02emt0u3429j")
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
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: plistOverrides),
            sources: ["Sources/**"],
            resources: ["ReSources/**"],
            entitlements: "./Entitlements/BridgingRelease.entitlements",
            dependencies: [
                .project(target: "Feature", path: "../Feature"),
            ],
            settings: .settings(
                base: SigningHelper.signingSettings,
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release"),
                ]
            )
        )
    ]
)
