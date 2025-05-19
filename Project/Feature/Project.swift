import ProjectDescription

let project = Project(
    name: "Feature",
    targets: [
        .target(
            name: "Feature",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.Wook.feature",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sources/**"], // 전체 서브폴더 포함됨
            resources: [],
            dependencies: [
                .project(target: "Core", path: "../Core"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "GoogleSignIn"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseStorage"),
                .external(name: "PinLayout"),
                .external(name: "SkeletonView"),
            ],
        )
    ]
)
