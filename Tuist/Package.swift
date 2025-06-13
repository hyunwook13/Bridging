// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RxCocoa": .framework,
            "RxCocoaRuntime": .framework,
            "RxRelay": .framework,
            "RxBlocking": .framework,
            "RxTest": .framework,
            "PinLayout": .framework,
            "SkeletonView": .framework,
            "GoogleSignIn": .framework,
            "GTMAppAuth": .framework
        ]
    )
#endif

let package = Package(
    name: "Bridging",
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.7.0")
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS.git",
//            .upToNextMajor(from: "8.0.0")
            .branchItem("main")
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            .branchItem("main")
        ),
        .package(
            url: "https://github.com/layoutBox/PinLayout",
            .branchItem("master")
        ),
        .package(
            url: "https://github.com/Juanpe/SkeletonView.git",
            .upToNextMajor(from: "1.7.0")
        )
    ]
)
