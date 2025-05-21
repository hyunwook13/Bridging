//
//  AppDelegate.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import UIKit

import FirebaseCore
import GoogleSignIn
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        //        BridgingLogger.logEvent("app_start")
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정 (MessagingDelegate 상속 필요)
        Messaging.messaging().delegate = self
        
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func checkToken() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
//            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
    }
}
extension AppDelegate {
    // UIKit은 앱을 APN에 성공적으로 등록한 후 이 메서드를 호출
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Firebase 에서 대리자로 APNs 토큰을 설정해주는 곳
          Messaging.messaging().apnsToken = deviceToken
    }
    
    //포그라운드 알림 수신: 로컬 / 푸시 동일
    //카카오톡: 도이님과 채팅방, 푸시마다 설정, 화면마다 설정 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as?
//                                    SceneDelegate)?.window?.rootViewController?.topVIewController else { return }

        //.banner, .list : iOS 14+
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    //푸시 클릭: 카카오톡 푸시 클릭 -> 카카오톡 푸시 온 채팅방으로 바로 이동
    //유저가 푸시를 클릭했을 때만 수신 확인 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("사용자가 푸시를 클릭했습니다.")
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SeSAC Project")
        } else {
            print("NOTHING")
        }
    }
}

extension AppDelegate: MessagingDelegate {
    //토큰 갱신 모니터링 : 토큰 정보가 언제 바뀔까?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
