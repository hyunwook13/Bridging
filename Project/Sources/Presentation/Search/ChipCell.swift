//
//  ChipCell.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit

import RxSwift
import RxCocoa
import PinLayout

final class ChipCell: UICollectionViewCell {
    static let reuseID = "ChipCell"

    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)
    lazy var stackView = UIStackView(arrangedSubviews: [removeButton])

    private var onRemoveTapped: (() -> Void)?
    private var isParent: Bool = true // ✅ 저장할 프로퍼티 추가

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor.systemGray5

        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label

        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = .lightGray

//        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout(isParent: isParent) // ✅ 저장된 isParent로 layout 호출
    }

    func configure(title: String, isParent: Bool, onRemove: (() -> Void)? = nil) {
        self.isParent = isParent
        titleLabel.text = title
//        onRemoveTapped = onRemove

        layout(isParent: isParent)

        if isParent {
            // 선택되지 않은 태그 (연령대, 성별, 카테고리)
            contentView.backgroundColor = UIColor(hex: "#FFDDD2")
            titleLabel.textColor = .label
            removeButton.tintColor = UIColor(hex: "#FFDDD2")//.darker() // 보조색과 어울리는 다크톤
        } else {
            // 선택된 태그 (남성, 여성 등)
            contentView.backgroundColor = UIColor(hex: "#E76F51")
            titleLabel.textColor = .white
            removeButton.tintColor = UIColor(hex: "#00AFB9") // 액센트 색상
        }
    }

    private func layout(isParent: Bool) {
        titleLabel.sizeToFit()

        if isParent {
            titleLabel.pin
                .left(16)
                .vCenter()

            stackView.isHidden = true
        } else {
            titleLabel.pin
                .left(12)
                .vCenter()

            stackView.isHidden = false
            stackView.pin
                .after(of: titleLabel, aligned: .center)
                .marginLeft(4)
                .size(16)
        }
    }

    @objc private func removeTapped() {
        onRemoveTapped?()
    }
}
