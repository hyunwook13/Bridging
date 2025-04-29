//
//  MainTableViewCell.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit

import PinLayout

final class MainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MainTableViewCell"
    
    private let genderLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 3
        lbl.layer.borderWidth = 1
        lbl.clipsToBounds = true
        return lbl
    }()
    // 연령대 라벨
    private let ageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 3
        lbl.layer.borderWidth = 1
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 4
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let clapIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let clapLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let commentIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "text.bubble"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let thumbnailView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        return iv
    }()
    
    // 3) 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        // 서브뷰 추가
        contentView.addSubview(genderLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(sectionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(clapIcon)
        contentView.addSubview(clapLabel)
        contentView.addSubview(commentIcon)
        contentView.addSubview(commentLabel)
        contentView.addSubview(thumbnailView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not supported")
    }
    
    // 4) PinLayout 레이아웃
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        genderLabel.pin
            .width(14)
            .height(17)
            .top(28)
            .left(8)
        
        ageLabel.pin
            .width(30)
            .height(17)
            .vCenter(to: genderLabel.edge.vCenter)
            .after(of: genderLabel).marginLeft(6)
        
        sectionLabel.pin
            .after(of: ageLabel, aligned: .center).marginLeft(6)
            .vCenter(to: ageLabel.edge.vCenter)
            .sizeToFit()
        
        titleLabel.pin
            .below(of: sectionLabel).marginTop(20)
            .left(to: genderLabel.edge.left)
            .right(40)
            .maxHeight(77.33)
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel).marginTop(12)
            .left(to: genderLabel.edge.left)
            .right(40)
            .maxHeight(34)
            .sizeToFit(.width)
        
        dateLabel.pin
            .below(of: subtitleLabel)
            .marginTop(20)
            .left(to: genderLabel.edge.left)
            .sizeToFit()
            .bottom(28)
        
        clapIcon.pin
            .after(of: dateLabel)
            .marginLeft(16)
            .vCenter(to: dateLabel.edge.vCenter)
            .size(CGSize(width: 14, height: 14))
        
        clapLabel.pin
            .after(of: clapIcon).marginLeft(4)
            .vCenter(to: clapIcon.edge.vCenter)
            .sizeToFit()
        
        commentIcon.pin
            .after(of: clapLabel).marginLeft(16)
            .vCenter(to: clapLabel.edge.vCenter)
            .size(CGSize(width: 14, height: 14))
        
        commentLabel.pin
            .after(of: commentIcon).marginLeft(4)
            .vCenter(to: commentIcon.edge.vCenter)
            .sizeToFit()
        
        thumbnailView.pin
            .top(to: titleLabel.edge.top)
            .after(of: titleLabel).marginLeft(40)
            .right(8)
            .aspectRatio(CGFloat(3.0/4.0))
    }
    
    // MARK: Configure
    func configure(with post: Post) {
        switch post.authorGender {
        case "남":
            genderLabel.text = post.authorGender
            let color = UIColor.systemBlue
            genderLabel.layer.borderColor = color.cgColor
            genderLabel.backgroundColor = color.withAlphaComponent(0.1)
            genderLabel.textColor = color
        case "여":
            genderLabel.text = post.authorGender
            let color = UIColor.systemPink
            genderLabel.layer.borderColor = color.cgColor
            genderLabel.backgroundColor = color.withAlphaComponent(0.1)
            genderLabel.textColor = color
        default:
            return
        }
        
        ageLabel.text = "\(post.authorAgeGroup)대"
        let ageColor: UIColor = {
            switch Int(post.authorAgeGroup)! {
            case 10: return .systemRed
            case 20: return .systemOrange
            case 30: return .systemYellow
            case 40: return .systemGreen
            case 50: return .systemBlue
            case 60: return .systemIndigo
            default: return .systemPurple
            }
        }()
        ageLabel.layer.borderColor = ageColor.cgColor
        ageLabel.backgroundColor = ageColor.withAlphaComponent(0.1)
        ageLabel.textColor = ageColor
        // 1) 제목, 내용
        sectionLabel.text = post.authorNickName
        titleLabel.text = post.title
        subtitleLabel.text = post.context
        
        // 2) 날짜 포맷팅
        let date = post.createdAt.dateValue()
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        dateLabel.text = df.string(from: date)
        
        // 3) 좋아요, 댓글 수
        clapLabel.text = "\(post.likeUserID.count)"
        commentLabel.text = "\(post.commentsID.count)"
        
        // 4) 썸네일 (여기선 간단히 동기 로드, 실제론 캐시/비동기 처리 필요)
        if let urlString = post.imageURL, let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            thumbnailView.image = UIImage(data: data)
        } else {
            thumbnailView.image = nil
        }
        
        // 레이아웃 업데이트
        setNeedsLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 1) Set the contentView's width to the specified size parameter
        contentView.pin.width(size.width)

        // 2) Layout the contentView's controls
        layout()
        let dateHeight = dateLabel.frame.maxY
        
        // 3) Returns a size that contains all controls
        return CGSize(width: contentView.frame.width, height: dateHeight + 28)
    }
}
