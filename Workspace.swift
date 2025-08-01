//
//  Workspace.swift
//  Packages
//
//  Created by 이현욱 on 5/6/25.
//

import ProjectDescription

let Bridging = Workspace(
    name: "Bridging",
    projects: [
        "Project/Domain",
        "Project/CommonUI",
        "Project/Core",
        "Project/Common",
        "Project/Feature",
        "Project/BridgingTests",
        "Project/Feature/FeatureSetting",
        "Project/Feature/FeaturePostDetail",
        "Project/Feature/FeaturePostCompose",
        "Project/Feature/FeatureLogin",
        "Project/Feature/FeatureOnBoarding",
        "Project/Feature/FeatureComments",
        "Project/Feature/FeatureSearch",
        "Project/Feature/FeatureMain",
        "Project/Bridging",
    ]
)

