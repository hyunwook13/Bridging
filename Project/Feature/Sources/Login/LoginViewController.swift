//
//  LoginViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import UIKit
import AuthenticationServices
import Core

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import RxSwift
import RxCocoa
import PinLayout

enum LoginType: String {
    case apple
    case google
}

public final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    fileprivate var currentNonce: String?
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppImage")
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityHint = "앱의 로고"
        imageView.isAccessibilityElement = true
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bridging"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Bridging"
        label.accessibilityHint = "앱의 제목"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 다양한 목소리를 하나로 연결하는 곳"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        label.accessibilityLabel = "당신의 다양한 목소리를 하나로 연결하는 곳"
        label.accessibilityHint = "앱의 부제목"
        return label
    }()
    
    private let googleLoginButton: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.style = .standard
        btn.isAccessibilityElement = true
        btn.accessibilityLabel = "구글 로그인 버튼"
        btn.accessibilityHint = "구글 계정으로 로그인"
        return btn
    }()
    
    private var appleLoginButton: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "애플계정으로 로그인"
        btn.accessibilityLabel = "애플 로그인 버튼"
        return btn
    }()
    
    private let exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인 없이 둘러보기", for: .normal)
        button.isAccessibilityElement = true
        button.accessibilityHint = "로그인 없이 둘러보기"
        button.accessibilityLabel = "로그인 없이 둘러보기"
        return button
    }()
    
    deinit {
        print("deinit LoginVC")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutInfo()
        layoutButtons()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateButtonStyles()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(appIconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(exploreButton)
    }
    
    private func layoutInfo() {
        appIconImageView.pin.top(view.pin.safeArea).margin(40)
            .hCenter()
            .width(120)
            .height(120)
        
        appNameLabel.pin.below(of: appIconImageView).marginTop(12)
            .hCenter()
            .sizeToFit()
        
        descriptionLabel.pin.below(of: appNameLabel).marginTop(12)
            .horizontally(24)
            .sizeToFit(.width)
    }
    
    private func layoutButtons() {
        exploreButton.pin
            .bottom(view.pin.safeArea)
            .marginBottom(20)
            .horizontally(32)
            .height(30)

        googleLoginButton.pin
            .above(of: exploreButton)
            .marginBottom(12)
            .horizontally(32)
            .height(50)

        appleLoginButton.pin
            .above(of: googleLoginButton)
            .marginBottom(12)
            .horizontally(32)
            .height(50)
    }
    
    // 버튼 스타일 변경
    private func updateButtonStyles() {
        if traitCollection.userInterfaceStyle == .dark {
            googleLoginButton.colorScheme = .light
            
            // 애플 버튼 교체
            appleLoginButton.removeFromSuperview()
            let newAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            view.addSubview(newAppleButton)
            appleLoginButton = newAppleButton
            layoutButtons() // 새 버튼 다시 레이아웃
        } else {
            googleLoginButton.colorScheme = .dark
            
            // 애플 버튼 교체
            appleLoginButton.removeFromSuperview()
            let newAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
            view.addSubview(newAppleButton)
            appleLoginButton = newAppleButton
            layoutButtons()
        }
        appleLoginButton.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                self?.startSignInWithAppleFlow()
            }.disposed(by: disposeBag)
    }
    
    private func bindActions() {
        googleLoginButton.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                print("Google 로그인 시도")
                self?.googleSignIn()
                // Google 로그인 로직 연결
            }
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                self?.startSignInWithAppleFlow()
            }.disposed(by: disposeBag)
        
        exploreButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
                print("로그인 없이 둘러보기")
            }
            .disposed(by: disposeBag)
    }
    
    private func startSignInWithAppleFlow() {
        BridgingLogger.logEvent("start_apple_login")
        let nonce = NonceManager.shared.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = NonceManager.shared.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func googleSignIn() {
        BridgingLogger.logEvent("start_google_login")
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return BridgingLogger.logEvent("fail_google_login", parameters: ["error": "No Client ID"])
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return BridgingLogger.logEvent("fail_google_login", parameters: ["error": error!.localizedDescription])
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return BridgingLogger.logEvent("fail_google_login", parameters: ["error": "user, idToken not found"])
            }
            //
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [unowned self] result, error in
                self.handleLogin(result: result, credential: credential, error: error, type: .google)
            }
        }
    }
    
    private func handleLogin(result: AuthDataResult?, credential: AuthCredential, error: (any Error)?, type: LoginType) {
        if let error = error {
            return BridgingLogger.logEvent("fail_\(type.rawValue)_login", parameters: ["error": error.localizedDescription])
        }
        
        guard let _ = result else {
            return BridgingLogger.logEvent("fail_\(type.rawValue)_login", parameters: ["error": "no value after login"])
        }
        
        DispatchQueue.main.async { [weak self] in
            if KeyChainManager.shared.isExistKeychain() {
                self?.dismiss(animated: true)
            } else {
                self?.navigationController?.pushViewController(OnboardingViewController(), animated: true)
            }
        }
        
                if let user = Auth.auth().currentUser {
//                    
                    print("=== 현재 유저 정보 ===")
                    print("UID: \(user.uid)")
                    print("이메일: \(user.email ?? "없음")")
                    print("이메일 인증됨: \(user.isEmailVerified)")
                    print("디스플레이 이름: \(user.displayName ?? "없음")")
                    print("전화번호: \(user.phoneNumber ?? "없음")")
                    print("프로필 사진 URL: \(user.photoURL?.absoluteString ?? "없음")")
                    print("프로바이더 ID: \(user.providerID)")
                    
                    print("=== 로그인한 Provider 목록 ===")
                    for info in user.providerData {
                        print("- Provider ID: \(info.providerID)")
                        print("  UID: \(info.uid)")
                        print("  이메일: \(info.email ?? "없음")")
                        print("  디스플레이 이름: \(info.displayName ?? "없음")")
                        print("  사진 URL: \(info.photoURL?.absoluteString ?? "없음")")
                    }
                    
                    user.getIDToken { token, error in
                        if let token = token {
                            print("ID Token: \(token)")
                        } else if let error = error {
                            print("ID Token 에러: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("현재 로그인된 유저가 없습니다.")
                }
//            } catch {
//                print("FireStore에 사용자 저장 실패: \(error.localizedDescription)")
//            }
//        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        return BridgingLogger.logEvent("fail_apple_login", parameters: ["error": error.localizedDescription])
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                return BridgingLogger.logEvent("fail_apple_login", parameters: ["error": "failed to get nonce"])
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return BridgingLogger.logEvent("fail_apple_login", parameters: ["error": "failed to get appleIDToken"])
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return BridgingLogger.logEvent("fail_apple_login", parameters: ["error": "failed to get apple idTokenString"])
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [unowned self] (result, error) in
                self.handleLogin(result: result, credential: credential, error: error, type: .apple)
            }
        }
    }
}
