//
//  SceneDelegate.swift
//  Feature
//
//  Created by 이현욱 on 5/29/25.
//

import UIKit

import Domain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = .init(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        window?.makeKeyAndVisible()
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
}
