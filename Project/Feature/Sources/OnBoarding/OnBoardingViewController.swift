//
//  OnBoardingViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import UIKit
import Core

import RxSwift
import RxCocoa
import PinLayout

class OnboardingViewController: UIViewController {
    // MARK: - UI Components
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력하세요"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let pickerView = UIPickerView()
    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("다음", for: .normal)
        btn.isEnabled = false
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    private let selectedGender = BehaviorRelay<String>(value: "남성")
    private let selectedAgeGroup = BehaviorRelay<String>(value: "10")
    private let nicknameRelay = BehaviorRelay<String>(value: "")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    private func setupHierarchy() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesBackButton = true
        self.title = "정보를 입력해주세요!"
        view.addSubview(nicknameTextField)
        view.addSubview(pickerView)
        view.addSubview(nextButton)
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setupBindings() {
        // 닉네임 바인딩
        nicknameTextField.rx.text.orEmpty
            .bind(to: nicknameRelay)
            .disposed(by: disposeBag)
        
        // 선택값 조합해 버튼 활성화
        let isFullFilled = Observable
            .combineLatest(nicknameRelay.map { !$0.isEmpty },
                           selectedGender.map { !$0.isEmpty },
                           selectedAgeGroup.map { !$0.isEmpty })
            .map { $0 && $1 && $2 }
        
        isFullFilled
            .bind { [weak self] full in
                guard let self = self else { return }
                // 상태에 따라 일반 파랑 or 반투명 파랑
                let normalBlue = UIColor.systemBlue
                let disabledBlue = normalBlue.withAlphaComponent(0.5)
                
                self.nextButton.backgroundColor = full ? normalBlue : disabledBlue
                self.nextButton.isEnabled = full              // 버튼 활성화/비활성화도 함께
            }
            .disposed(by: disposeBag)
        
        // 버튼 터치
        nextButton.rx.tap
            .withUnretained(self)
            .flatMapLatest { _ -> Single<Bool> in
                let user = UserProfile(ageGroup: self.selectedAgeGroup.value,
                                       gender: Gender(rawValue: self.selectedGender.value) ?? .man,
                                       nickname: self.nicknameRelay.value,
                                       posts: [])
                
                return FireStoreManager.shared.addUser(user)
            }
            .asObservable()
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    self.dismiss(animated: true)
                } else {
                    HapticManager.shared.notify(.error)
                }
            }, onError: { error in
                HapticManager.shared.notify(.error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    private func layoutViews() {
        nicknameTextField.pin
            .top(view.pin.safeArea.top + 20)
            .horizontally(20)
            .height(44)
        
        pickerView.pin
            .below(of: nicknameTextField).marginTop(20)
            .horizontally(20)
            .height(150)
        
        nextButton.pin
            .below(of: pickerView).marginTop(30)
            .horizontally(20)
            .height(50)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension OnboardingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? Gender.allCases.count : AgeGroup.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? Gender.allCases[row].rawValue : (AgeGroup.allCases[row].rawValue + "대")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedGender.accept(Gender.allCases[row].rawValue)
        } else {
            selectedAgeGroup.accept(AgeGroup.allCases[row].rawValue)
        }
    }
}
