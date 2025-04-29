//
//  DetailPostViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/29/25.
//

import UIKit
import PinLayout

final class PostComposeViewController: UIViewController {
    // MARK: - UI Elements
    private let navBar = UIView()
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("뒤로가기", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        btn.setTitleColor(UIColor(hex: "E76F51"), for: .normal)
        return btn
    }()
    private let titleLabel = UILabel()
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(UIColor(hex: "E76F51"), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    private let separatorLine = UIView()
    
    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목을 입력하세요"
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        tf.textColor = UIColor(hex: "222222")
        return tf
    }()
    private let titleBottomLine = UIView()
    private let titleCounterLabel: UILabel = {
        let lbl = UILabel(); lbl.font = .systemFont(ofSize: 12); lbl.textColor = .lightGray; return lbl
    }()
    
    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.textColor = UIColor(hex: "333333")
        tv.text = "내용을 입력하세요..."
        tv.textColor = .lightGray
        return tv
    }()
    
    private let imageAddButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.setTitle("\n📷 이미지 추가", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.darkGray, for: .highlighted)
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()
    private let addedImageView = UIImageView()
    private let removeImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("✕", for: .normal)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private let optionsContainer = UIView()
    private let authorTagLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.text = "작성자: 30대 남성"
        return lbl
    }()
    private let categoryControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["사회","문화","정치","경제","기타"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = UIColor(hex: "E76F51")
        return sc
    }()
    private let scopeSwitch = UISwitch()
    private let scopeLabel: UILabel = {
        let lbl = UILabel(); lbl.text = "전체 공개"; lbl.font = .systemFont(ofSize: 15, weight: .medium); lbl.textColor = .darkGray; return lbl
    }()
    private let topicField: UITextField = {
        let tf = UITextField(); tf.placeholder = "토론 주제 (선택사항)"; tf.font = .systemFont(ofSize: 15, weight: .medium); tf.backgroundColor = UIColor(hex: "F0F0F0"); tf.layer.cornerRadius = 6; return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSubviews()
        bindActions()
    }
    
//    init
    
    private func configureSubviews() {
        [navBar, titleField, titleBottomLine, titleCounterLabel,
         contentTextView, imageAddButton, addedImageView, removeImageButton,
         optionsContainer].forEach { view.addSubview($0) }
        
        // navBar subviews
        [backButton, titleLabel, doneButton, separatorLine].forEach { navBar.addSubview($0) }
        [authorTagLabel, categoryControl, scopeLabel, scopeSwitch, topicField].forEach { optionsContainer.addSubview($0) }
        
        // static texts
        titleLabel.text = "게시물 작성"
        separatorLine.backgroundColor = UIColor(hex: "EEEEEE")
        titleBottomLine.backgroundColor = UIColor(hex: "EEEEEE")
        titleCounterLabel.text = "0/50"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        navBar.pin.top(view.pin.safeArea).horizontally().height(44)
        backButton.pin.left(16).vCenter()
        doneButton.pin.right(16).vCenter()
        titleLabel.pin.hCenter().vCenter()
        separatorLine.pin.bottom().horizontally().height(1)
        
        titleField.pin.below(of: navBar).horizontally(16).height(60)
        titleBottomLine.pin.below(of: titleField).horizontally(16).height(1)
        titleCounterLabel.pin.right(16).vCenter(to: titleField.edge.bottom).sizeToFit()
        
//        contentTextView.pin.below(of: titleBottomLine).horizontally(16).top(+=12).height(150)
        
        if addedImageView.image == nil {
            imageAddButton.pin.below(of: contentTextView).horizontally(16).height(60)
        } else {
            addedImageView.pin.below(of: contentTextView).horizontally(16).height(180)
            removeImageButton.pin.size(24).top(to: addedImageView.edge.top).right(to: addedImageView.edge.right)
        }
        
        optionsContainer.pin.below(of: addedImageView.image == nil ? imageAddButton : addedImageView)
            .horizontally(16).height(120)
        authorTagLabel.pin.top(8).left()
        categoryControl.pin.below(of: authorTagLabel).horizontally().height(32)
        scopeLabel.pin.below(of: categoryControl).left()
        scopeSwitch.pin.after(of: scopeLabel, aligned: .center).marginLeft(8)
        topicField.pin.below(of: scopeLabel).horizontally().height(36)
    }
    
    private func bindActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        titleField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
        imageAddButton.addTarget(self, action: #selector(didTapAddImage), for: .touchUpInside)
        removeImageButton.addTarget(self, action: #selector(didTapRemoveImage), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapBack() {
        // 뒤로가기 로직
    }
    @objc private func didTapDone() {
        // 완료 로직
    }
    @objc private func titleChanged() {
        let count = titleField.text?.count ?? 0
        titleCounterLabel.text = "\(count)/50"
        doneButton.isEnabled = count > 0
    }
    @objc private func didTapAddImage() {
        // 이미지 선택 로직 (갤러리/카메라)
    }
    @objc private func didTapRemoveImage() {
        addedImageView.image = nil
        view.setNeedsLayout()
    }
}
