//
//  SceneDelegate.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import UIKit

import Feature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRequiredLogin),
            name: NSNotification.Name("requiredLogin"),
            object: nil
        )
        
        // 1) Create window
        let window = UIWindow(windowScene: windowScene)
        
        // 2) Home (Main) tab
        let homeVC = MainViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // 3) Settings tab
        let settingsVC = SettingViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.navigationBar.prefersLargeTitles = true
        settingsNav.title = "설정"
        settingsNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        let tabBar = UITabBarController()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()       // ★ 필수
        appearance.backgroundColor = .systemBackground  // 탭바 배경색
        tabBar.tabBar.standardAppearance = appearance
        tabBar.tabBar.scrollEdgeAppearance = appearance
        
        tabBar.viewControllers = [homeNav, settingsNav]
        
        // 5) Assign root and show
        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }
    
    @objc private func handleRequiredLogin() {
        guard let rootVC = window?.rootViewController,
              let topVC = SceneDelegate.topViewController(from: rootVC) else {
            return
        }
        let alert = UIAlertController(
            title: "로그인이 필요합니다",
            message: "이 기능을 사용하려면 로그인이 필요합니다.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let loginVC = UINavigationController(rootViewController: LoginViewController())
            loginVC.modalPresentationStyle = .fullScreen
            topVC.present(loginVC, animated: true)
        }))

        topVC.present(alert, animated: true)
    }

    // 현재 가장 상위에 있는 VC 찾기
    static func topViewController(from vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return topViewController(from: nav.visibleViewController)
        } else if let tab = vc as? UITabBarController,
                  let selected = tab.selectedViewController {
            return topViewController(from: selected)
        } else if let presented = vc?.presentedViewController {
            return topViewController(from: presented)
        } else {
            return vc
        }
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
        print("SceneDelegate - sceneWillEnterForeground - 켜지기 전 1 (완전 백그라운드로 갔다 다시 돌아올 때) 백그라운드로 갔다가 바로 오면 여기 안탐. 백그라운드 1초 있다가 켜야 여기 탐")
        callBackgroundImage()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("SceneDelegate - sceneDidEnterBackground - 백그라운드로 갔을 때, 홈 눌렀을 때")
        callBackgroundImage(true)
    }
    
    private func callBackgroundImage(_ isShow: Bool = false) {
        let TAG_BG_IMG = -101
        
        guard let baseWindow = window?.rootViewController?.view.window else { return }

        if isShow {
            // 이미 있으면 아무것도 하지 않음
            if baseWindow.viewWithTag(TAG_BG_IMG) != nil { return }

            let splashVC = SplashViewController()
            let splashView = splashVC.view!
            splashView.tag = TAG_BG_IMG
            splashView.frame = baseWindow.bounds
            splashView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            baseWindow.addSubview(splashView)
        } else {
            // 있을 때만 제거
            if let splash = baseWindow.viewWithTag(TAG_BG_IMG) {
                splash.removeFromSuperview()
            }
        }
    }
}

