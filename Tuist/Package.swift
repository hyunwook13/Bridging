// swift-tools-version: 5.9

import PackageDescription


#if TUIST
import ProjectDescription


let packageSettings = PackageSettings(
    productTypes: [
        "RXswift": .framework, // default is .staticFramework
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
            .upToNextMajor(from: "8.0.0")
        ),
        .package(
            url: "https://github.com/supabase/supabase-swift.git",
            .upToNextMajor(from: "2.0.0")
        ),
    ]
)
