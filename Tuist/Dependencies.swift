//
//  Dependencies.swift
//  Packages
//
//  Created by 이현욱 on 5/6/25.
//

import ProjectDescription

let package = Dependencies(
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
