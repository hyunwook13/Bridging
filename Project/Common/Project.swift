import ProjectDescription

let project = Project(
    name: "Common",
    targets: [
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.Wook.Common",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default, // 필요 시 .extendingDefault(with:)로 변경 가능
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .external(name: "FirebaseCore", condition: .when([.ios])),
                .external(name: "FirebaseAuth", condition: .when([.ios])),
                .external(name: "FirebaseFirestore", condition: .when([.ios])),
                .external(name: "FirebaseStorage", condition: .when([.ios])),
                .external(name: "FirebaseAnalytics", condition: .when([.ios])),
                .external(name: "FirebaseCrashlytics", condition: .when([.ios])),
                .external(name: "FirebaseMessaging", condition: .when([.ios])),
                .external(name: "GoogleSignIn", condition: .when([.ios])),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                
            ],
        ),
    ]
)

