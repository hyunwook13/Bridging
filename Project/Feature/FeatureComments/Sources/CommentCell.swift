//
//  CommentCell.swift
//  Feature
//
//  Created by 이현욱 on 5/28/25.
//

//
//  CommentCell.swift
//  Feature
//
//  Created by 이현욱 on 5/28/25.
//

import UIKit
import Core
import PinLayout

// MARK: - CommentCell
final class CommentCell: UITableViewCell {
    static let reuseIdentifier = "CommentCell"
    
    private let nicknameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .bold)
        lbl.textColor = .label
        return lbl
    }()
    
    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    private let voteLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .systemBlue
        return lbl
    }()
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    private let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        topStack.addArrangedSubview(nicknameLabel)
        topStack.addArrangedSubview(infoLabel)
        topStack.addArrangedSubview(voteLabel)
        
        contentView.addSubview(topStack)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        let padding: CGFloat = 16
        
        topStack.pin
            .top(padding)
            .left(padding)
            .right(padding)
            .minHeight(15)
            .sizeToFit(.width)
        
        contentLabel.pin
            .below(of: topStack)
            .marginTop(4)
            .left(padding)
            .right(padding)
            .sizeToFit(.width)
        
        dateLabel.pin
            .below(of: contentLabel)
            .marginTop(4)
            .left(padding)
            .sizeToFit()
        
        let h = dateLabel.frame.maxY + padding
        contentView.frame.size.height = h
    }
    
    func configure(with comment: CommentDTO) {
        nicknameLabel.text = comment.authorNickName
        contentLabel.text = comment.content
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: comment.createdAt.dateValue())
        
        infoLabel.text = "\(comment.gender.rawValue), \(comment.authorAgeGroup.rawValue)"
        
        voteLabel.text = ""
        switch comment.vote {
        case .agree:
            voteLabel.text = "찬성"
            voteLabel.textColor = .systemBlue
        case .disagree:
            voteLabel.text = "반대"
            voteLabel.textColor = .systemRed
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        let height = dateLabel.frame.maxY + 16
        return CGSize(width: size.width, height: height)
    }
}
