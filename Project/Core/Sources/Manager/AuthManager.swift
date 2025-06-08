//
//  AuthManager.swift
//  Bridging
//
//  Created by 이현욱 on 4/29/25.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

public final class AuthManager {
    public static let shared = AuthManager()
    private let disposeBag = DisposeBag()
    private let profileService: UserProfileService
    
    public let userRelay = BehaviorRelay<User?>(value: Auth.auth().currentUser)
    
    public let profileRelay = BehaviorRelay<UserProfile?>(value: nil)
    
    private var user: User? {
        userRelay.value
    }
    
    private var lastUUID: String?
    
    private var profile: UserProfile? {
        return profileRelay.value
    }
    
    private var authHandler: AuthStateDidChangeListenerHandle?
    private var tokenHandler: AuthStateDidChangeListenerHandle?
    
    private init(profileService: UserProfileService = FireStoreManager.shared) {
        self.profileService = profileService
        print("init")
        refreshProfile()
        
        authHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            BridgingLogger.logEvent("didChangeListener", parameters: ["uid": user?.uid ?? ""])
            self?.handleAuthStateChange(user: user)
        }
        
//        tokenHandler = Auth.auth().addIDTokenDidChangeListener { [weak self] _, user in
//            BridgingLogger.logEvent("IDTokenDidChangeListener", parameters: ["uid": user?.uid ?? ""])
//            self?.handleAuthStateChange(user: user)
//        }
    }
    
    deinit {
        if let handle = authHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        if let handle = tokenHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func handleAuthStateChange(user: User?) {
        if let newUser = user {
            userRelay.accept(newUser)
//            refreshProfile()
        } else {
            signout()
        }
    }
    
    private func refreshProfile() {
        if let user = user, user.uid != lastUUID {
            let createdAt = user.metadata.creationDate ?? Date()
            if !(abs(Date().timeIntervalSince(createdAt)) < 15) {
                lastUUID = user.uid
                
                profileService.fetchProfile(for: user.uid)
                    .asObservable()
                    .subscribe(onNext: {
                        self.profileRelay.accept($0)
                        BridgingLogger.logEvent("success fetch user", parameters: ["uid": $0.uuid ?? ""])
                    }, onError: { error in
                        BridgingLogger.logEvent("error with fetch user", parameters: ["error": error.localizedDescription])
                        self.signout()
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    public func signout() {
        do {
            try Auth.auth().signOut()
            userRelay.accept(nil)
        } catch {
            BridgingLogger.logEvent("error_with_signOut", parameters: ["error": error.localizedDescription])
        }
    }
    
    func isLoggedIn() -> Bool {
        return user != nil
    }
}

extension ObservableType {
    /// 로그인 상태면 자신을, 아니면 로그인 화면 띄우고 빈 시퀀스를 반환
//    public func requireLogin() -> Observable<Element> {
//        return AuthManager.shared.userRelay
////            .skip(2)
//            .flatMapLatest { user -> Observable<Element> in
//                if user != nil {
//                    return self.asObservable()  // 로그인 됐으니 원본 이벤트 흘려보냄
//                } else {
//                    // 로그인 화면 전환
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "requiredLogin"), object: nil)
//                    return .empty()            // 이후 스트림 차단
//                }
//            }
//    }
    
    public func requireLogin() -> Observable<Element> {
        return self
            .withLatestFrom(AuthManager.shared.userRelay) { element, user in
                (element, user)
            }
            .flatMapLatest { element, user in
                if user != nil {
                    return Observable.just(element)
                } else {
                    NotificationCenter.default.post(name: .init("requiredLogin"), object: nil)
                    return .empty()
                }
            }
    }
}
