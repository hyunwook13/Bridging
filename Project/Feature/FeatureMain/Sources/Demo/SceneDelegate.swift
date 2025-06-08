//
//  SceneDelegate.swift
//  Feature
//
//  Created by 이현욱 on 5/29/25.
//

import UIKit

import Core


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = CommentsViewController(post: mockPost())
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        //      supabase.auth.handle(url)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        callBackgroundImage()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        callBackgroundImage(true)
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        callBackgroundImage()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        callBackgroundImage(true)
    }
    
    private func callBackgroundImage(_ isShow: Bool = false) {
        let TAG_BG_IMG = -101
        
        guard let baseWindow = window?.rootViewController?.view.window else { return }

        if isShow {
            // 이미 있으면 아무것도 하지 않음
            if baseWindow.viewWithTag(TAG_BG_IMG) != nil { return }
//
//            let splashVC = SplashViewController()
//            let splashView = splashVC.view!
//            splashView.tag = TAG_BG_IMG
//            splashView.frame = baseWindow.bounds
//            splashView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            baseWindow.addSubview(splashView)
        } else {
            // 있을 때만 제거
            if let splash = baseWindow.viewWithTag(TAG_BG_IMG) {
                splash.removeFromSuperview()
            }
        }
    }
    
    private func mockPost() -> Post {
        return PostBuilder.shared
            .setTitle("AI 기술이 일자리를 없애는가 vs AI가 새로운 일자리를 창출하는가")
            .setCreatedUserID(UUID().uuidString)
            .setVotes([])
            .setAuthorGender(.woman)
            .setContext("현재 많은 AI가 생기고 있고, 그 능력은 시간이 지날수록 점점 더 강해지고, 범위 또한 넓어지고 있다. 과연 AI의 기술이 기존에 있던 일자리를 없애는가 혹은 새로운 일자리를 창출하는가?")
            .setAuthorAgeGroup(.thirties)
            .build()
    }
}

