//
//  SettingViewController.swift
//  Bridging
//
//  Created by 이현욱 on 5/1/25.
//

import UIKit
import Core

import RxSwift
import RxCocoa

public class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let authButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        return btn
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "설정"
        view.backgroundColor = .systemBackground
        view.addSubview(authButton)
        bindAuthState()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // authButton layout below nav bar
        authButton.pin
            .top(view.pin.safeArea).marginTop(16)
            .hCenter()
            .width(200)
            .height(44)
    }

    private func bindAuthState() {
        // Observe user login state
        AuthManager.shared.userRelay
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                if user != nil {
                    self.authButton.setTitle("로그아웃", for: .normal)
                    self.authButton.setTitleColor(.systemRed, for: .normal)
                    self.authButton.layer.borderColor = UIColor.systemRed.cgColor
                    self.authButton.rx.tap
                        .bind { _ in
//                            do {
                                 AuthManager.shared.signout()
//                            } catch {
//                                print("Sign out error: \(error)")
//                            }
                        }
                        .disposed(by: self.disposeBag)
                } else {
                    self.authButton.setTitle("로그인", for: .normal)
                    self.authButton.setTitleColor(.systemBlue, for: .normal)
                    self.authButton.layer.borderColor = UIColor.systemBlue.cgColor
                    self.authButton.rx.tap
                        .bind { [weak self] _ in
                            let loginVC = LoginViewController()
                            let nav = UINavigationController(rootViewController: loginVC)
                            nav.modalPresentationStyle = .fullScreen
                            self?.present(nav, animated: true)
                        }
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
