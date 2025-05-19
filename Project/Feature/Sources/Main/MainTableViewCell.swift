//
//  MainTableViewCell.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit
import Core

import PinLayout
import SkeletonView

final class MainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MainTableViewCell"
    
    private static let sizingCell: MainTableViewCell = {
        let cell = MainTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.layoutIfNeeded()
        return cell
    }()
    
    //— Dynamic height API
    static func height(for post: Post, width: CGFloat) -> CGFloat {
        let cell = sizingCell
        cell.prepareForReuse()
        cell.configure(with: post) { }
        let fittingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        return cell.sizeThatFits(fittingSize).height
    }
    static func skeletonHeight(width: CGFloat) -> CGFloat {
        let cell = sizingCell
        cell.prepareForReuse()
        // Skeleton 전용 세팅
        cell.hasImageURL = false
        cell.thumbnailView.image = nil
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.contentView.showSkeleton()
        
        let fitting = CGSize(width: width, height: .greatestFiniteMagnitude)
        return cell.sizeThatFits(fitting).height
    }
    
    private var hasImageURL: Bool = false
    
    private let genderLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textAlignment = .center

        return lbl
    }()
    private let ageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textAlignment = .center
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [genderLabel, ageLabel, sectionLabel,
         titleLabel, subtitleLabel, dateLabel,
         clapIcon, clapLabel, commentIcon,
         commentLabel, thumbnailView].forEach {
            contentView.addSubview($0)
            $0.isSkeletonable = true
        }
        
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        let height = dateLabel.frame.maxY + 28
        return CGSize(width: size.width, height: height)
    }
    
    private func setting() {
        selectionStyle = .none
        self.isSkeletonable = true // <-
        self.contentView.isSkeletonable = true // <-
    }
    
    private func layout() {
        let paddingH: CGFloat = 8
        let paddingV: CGFloat = 28
        let margin: CGFloat = 6
        
        genderLabel.pin
            .top(paddingV)
            .left(paddingH)
            .width(28)
            .height(17)
        ageLabel.pin
            .vCenter(to: genderLabel.edge.vCenter)
            .after(of: genderLabel).marginLeft(margin)
            .width(30)
            .height(17)
        sectionLabel.pin
            .vCenter(to: ageLabel.edge.vCenter)
            .after(of: ageLabel).marginLeft(margin)
            .sizeToFit()
        
        // Reserve or collapse thumbnail space based on hasImageURL
        if hasImageURL {
            thumbnailView.isHidden = false
            thumbnailView.pin
                .top(to: titleLabel.edge.top)
                .right(paddingH)
                .width(80)
                .aspectRatio(4.0/3.0)
        } else {
            thumbnailView.isHidden = true
            thumbnailView.pin
                .width(0)
                .height(0)
        }
        
        // Title and subtitle with dynamic right inset
        let rightInset = hasImageURL ? (30 + 80 + paddingH) : 40
        titleLabel.pin
            .below(of: sectionLabel).marginTop(20)
            .left(to: genderLabel.edge.left)
            .right(rightInset)
            .maxHeight(77.33)
            .sizeToFit(.width)
        subtitleLabel.pin
            .below(of: titleLabel).marginTop(12)
            .left(to: genderLabel.edge.left)
            .right(rightInset)
            .maxHeight(34)
            .sizeToFit(.width)
        
        dateLabel.pin
            .below(of: subtitleLabel).marginTop(20)
            .left(to: genderLabel.edge.left)
            .sizeToFit()
            .bottom(paddingV)
        clapIcon.pin
            .vCenter(to: dateLabel.edge.vCenter)
            .after(of: dateLabel).marginLeft(16)
            .size(CGSize(width: 14, height: 14))
        clapLabel.pin
            .vCenter(to: clapIcon.edge.vCenter)
            .after(of: clapIcon).marginLeft(4)
            .sizeToFit()
        commentIcon.pin
            .vCenter(to: clapLabel.edge.vCenter)
            .after(of: clapLabel).marginLeft(16)
            .size(CGSize(width: 14, height: 14))
        commentLabel.pin
            .vCenter(to: commentIcon.edge.vCenter)
            .after(of: commentIcon).marginLeft(4)
            .sizeToFit()
    }
    
    func configure(with post: Post, completion: (() -> Void)? = nil) {
        if !post.isTemporaryFlag {
            self.contentView.showSkeleton()
            return
        }
        
        contentView.hideSkeleton()
        configureCell(with: post)
        
        // 2) 이미지 로딩 전엔 thumbnailView 에만 스켈레톤
        thumbnailView.image = nil
        thumbnailView.isSkeletonable = true
        thumbnailView.showAnimatedSkeleton()
        
        // 3) 이미지 URL이 없으면, 스켈레톤만 숨기고 리턴
        guard let uuid = post.imageURL, !uuid.isEmpty else {
            thumbnailView.hideSkeleton()
            completion?()
            return
        }
        
        hasImageURL = true
        
        // 4) 비동기 이미지 로드
        
        completion?()
        
        Task {
            do {
                let img = try await StorageManager.shared.fetchPostImage(uuid: uuid)
                DispatchQueue.main.async {
                    // 5) 이미지 준비되면 스켈레톤만 지우고, 이미지만 교체
                    self.thumbnailView.hideSkeleton()
                    self.thumbnailView.image = img
                    
                    // 6) 레이아웃 필요 시 갱신
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                    
//                    completion?()
                }
            } catch {
                // 에러 시 스켈레톤은 숨겨 두고
                DispatchQueue.main.async {
                    self.thumbnailView.hideSkeleton()
//                    completion?()
                }
            }
        }
    }
    
    
//    func configure(with post: Post, completion: (()->())?) {
//        if !post.isTemporaryFlag {
//            self.contentView.showSkeleton()
//            return
//        }
//    
//        if post.imageURL?.isEmpty == false, let uuid = post.imageURL {
//            Task {
//                do {
//                    let image = try await StorageManager.shared.fetchPostImage(uuid: uuid)
//                    DispatchQueue.main.async {
//                        self.thumbnailView.image = image
//                        
//                        self.contentView.hideSkeleton()
//                        self.configureCell(with: post)
//                        self.setNeedsLayout()
//                        self.layoutIfNeeded()
//                        completion?()
//                        return
//                    }
//                } catch {
//                    
//                }
//            }
//        } else {
//            self.contentView.hideSkeleton()
//            self.configureCell(with: post)
//            setNeedsLayout()
//            self.layoutIfNeeded()
//            
//            completion?()
//            return
//        }
//    }
    
    private func configureCell(with post: Post) {
        genderLabel.layer.cornerRadius = 3
        genderLabel.layer.borderWidth = 1
        genderLabel.clipsToBounds = true
        
        ageLabel.layer.cornerRadius = 3
        ageLabel.layer.borderWidth = 1
        ageLabel.clipsToBounds = true
        genderLabel.text = post.authorGender.rawValue
        
        switch post.authorGender {
        case .man:
            let color = UIColor.systemBlue
            genderLabel.layer.borderColor = color.cgColor
            genderLabel.backgroundColor = color.withAlphaComponent(0.1)
            genderLabel.textColor = color
        case .woman:
            let color = UIColor.systemPink
            genderLabel.layer.borderColor = color.cgColor
            genderLabel.backgroundColor = color.withAlphaComponent(0.1)
            genderLabel.textColor = color
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
        subtitleLabel.text = post.content
        
        // 2) 날짜 포맷팅
        let date = post.createdAt.dateValue()
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        dateLabel.text = df.string(from: date)
        
        // 3) 좋아요, 댓글 수
        clapLabel.text = "\(post.likeUserID.count)"
        commentLabel.text = "\(post.commentsID.count)"
    }
}
