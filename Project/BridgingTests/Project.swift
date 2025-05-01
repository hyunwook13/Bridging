import ProjectDescription

let project = Project(
    name: "Tests",
    targets: [
        .target(
            name: "BridgingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.Wook.BridgingTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default, // 필요 시 .extendingDefault(with:)로 변경 가능
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxBlocking"),
                .external(name: "RxTest"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseStorage"),
            ]
        )
    ]
)

