//
//  OpinionAlertViewController.swift
//  Feature
//
//  Created by 이현욱 on 5/27/25.
//

import UIKit

import RxSwift
import RxCocoa
import PinLayout

public final class OpinionAlertViewController: UIViewController {
    private let disposeBag = DisposeBag()
    weak var delegate: SelecteOpinionDelegate?
    
    // Dimmed background
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    // Container for the alert
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    // Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이 주제에 어떤 의견이십니까?"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // Close (X) button
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.tintColor = .darkGray
        return button
    }()

    // Agree button
    private let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("찬성", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    // Disagree button
    private let disagreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("반대", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    deinit {
        print("deinit OpinionAlertViewController")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(agreeButton)
        containerView.addSubview(disagreeButton)
        
        bind()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Fullscreen dimmed background
        backgroundView.pin.all()
        
        // Container centered, 80% width, dynamic height
        containerView.pin
            .hCenter()
            .vCenter()
            .width(view.frame.width * 0.8)
            .height(180)
//            .sizeToFit(.width)

        // Title label at top inside container
        titleLabel.pin
            .top(20)
            .hCenter()
            .width(containerView.frame.width - 32)
            .sizeToFit(.width)

        // Close button at top-right inside container
        closeButton.pin
            .top(12)
            .right(12)
            .width(32)
            .height(32)

        // Agree and Disagree buttons at bottom
        agreeButton.pin
            .below(of: titleLabel)
            .marginTop(20)
            .left(32)
            .sizeToFit()
            .bottom(20)

        disagreeButton.pin
            .below(of: titleLabel)
            .marginTop(20)
            .right(32)
            .sizeToFit()
            .bottom(20)
    }
    
    private func bind() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: false)
            }.disposed(by: disposeBag)
        
        agreeButton.rx.tap
            .bind { [weak self] in
                self?.delegate?.selectedOpinion(.agree)
                self?.dismiss(animated: false)
            }.disposed(by: disposeBag)
        
        disagreeButton.rx.tap
            .bind { [weak self] in
                self?.delegate?.selectedOpinion(.disagree)
                self?.dismiss(animated: false)
            }.disposed(by: disposeBag)
    }
}
