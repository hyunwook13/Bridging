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
        let label = UILabel()
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    private let ageLabel: UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.accessibilityHint = "작성자 연령대"
        return label
    }()
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
//            .systemFont(ofSize: 16, weight: .bold)
        label.accessibilityTraits = .header
        label.accessibilityHint = "게시물 의견"

        label.numberOfLines = 4
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
//        label.font = .systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.accessibilityHint = "게시물 내용"
//        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
//        label.font = .systemFont(ofSize: 12)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.accessibilityHint = "게시물 작성 날짜"
        return label
    }()
    private let clapIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        iv.contentMode = .scaleAspectFit
//        label.accessibilityHint = "게시물 작성 날짜"
        return iv
    }()
    private let clapLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
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
        label.font = .preferredFont(forTextStyle: .footnote)
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
//        contentView.pin.width(size.width)
//        layout()
//        print("----------")
//        print(subtitleLabel.frame.height)
//        print(subtitleLabel.text)
//        print("----------")
//        let height = dateLabel.frame.maxY + 28
//        return CGSize(width: size.width, height: height)
        
        let isFinalPass = size.height == .greatestFiniteMagnitude
        // or: let isFinalPass = (size.width == tableView.bounds.width)
        contentView.pin.width(size.width)
        layout()  // PinLayout 레이아웃
        if isFinalPass {
            // 마지막 패스일 때만 다시 그리기
            setNeedsLayout()
            layoutIfNeeded()
        }
        let height = dateLabel.frame.maxY + 28
        return CGSize(width: size.width, height: height)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layout()
    }
    
    private func setting() {
//        isAccessibilityElement = false
//        self.accessibilityLabel = "포스트 정보, 자세한 정보를 얻으려면 선택하세요."
        self.accessibilityElements = [genderLabel, ageLabel, sectionLabel, titleLabel, subtitleLabel, dateLabel, clapIcon, clapLabel, commentIcon, commentLabel]
        selectionStyle = .none
        self.isSkeletonable = true // <-
        self.contentView.isSkeletonable = true // <-
    }
    
    internal func layout() {
        let paddingH: CGFloat = 8
        let paddingV: CGFloat = 28
        let margin: CGFloat = 6
        
        let genderLabelHeight = lineHeight(for: .footnote)
        genderLabel.pin
            .top(paddingV)
            .left(paddingH)
            .sizeToFit()
            .minWidth(28)
            .maxWidth(50)
            .minHeight(genderLabelHeight + 2)
        
        ageLabel.pin
            .vCenter(to: genderLabel.edge.vCenter)
            .after(of: genderLabel).marginLeft(margin)
            .sizeToFit()
            .minHeight(genderLabelHeight + 2)
            .minWidth(30)
        
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
        sectionLabel.pin
            .vCenter(to: ageLabel.edge.vCenter)
            .after(of: ageLabel).marginLeft(margin)
            .right(rightInset)
            .sizeToFit(.widthFlexible)
            .minHeight(genderLabelHeight + 2)
//            .minWidth(30)
        
        let titleHeight = lineHeight(for: .title3)
        titleLabel.pin
            .below(of: genderLabel).marginTop(16)
            .left(to: genderLabel.edge.left)
            .right(rightInset)
            .maxHeight(titleHeight > 36 ? titleHeight * 2 : titleHeight * 4)
            .minHeight(titleHeight)
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel).marginTop(12)
            .left(to: genderLabel.edge.left)
            .right(rightInset)
            .minHeight(titleHeight)
            .maxHeight(titleHeight > 36 ? titleHeight * 2 : titleHeight * 3)
            .sizeToFit(.width)
            
        dateLabel.pin
            .below(of: subtitleLabel).marginTop(20)
            .left(to: genderLabel.edge.left)
            .minWidth(14.33)
            .maxHeight(34)
            .minHeight(15.67)
            .bottom(paddingV)
            .sizeToFit()
        
        clapIcon.pin
            .vCenter(to: dateLabel.edge.vCenter)
            .after(of: dateLabel).marginLeft(16)
            .size(CGSize(width: 14, height: 14))
        clapLabel.pin
            .vCenter(to: clapIcon.edge.vCenter)
            .after(of: clapIcon).marginLeft(4)
            .sizeToFit()
            .minWidth(14.33)
            .minHeight(genderLabelHeight + 2)
            .maxWidth(40)
//            .minHeight(14.33)
        commentIcon.pin
            .vCenter(to: clapLabel.edge.vCenter)
            .after(of: clapLabel).marginLeft(16)
            .size(CGSize(width: 14, height: 14))
        commentLabel.pin
            .vCenter(to: commentIcon.edge.vCenter)
            .after(of: commentIcon).marginLeft(4)
            .sizeToFit()
            .minWidth(14.33)
            .minHeight(genderLabelHeight + 2)
            .maxWidth(40)
    }
    
    func configure(with post: Post, completion: (() -> Void)? = nil) {
        if !post.isTemporaryFlag {
            self.contentView.showSkeleton()
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.contentView.hideSkeleton()
        } completion: {
            if $0 {
                self.configureCell(with: post)
            }
        }
           
        // 2) 이미지 로딩 전엔 thumbnailView 에만 스켈레톤
        thumbnailView.image = nil
        
        thumbnailView.showAnimatedSkeleton()
        
        // 3) 이미지 URL이 없으면, 스켈레톤만 숨기고 리턴
        guard let uuid = post.imageURL, !uuid.isEmpty else {
            thumbnailView.hideSkeleton()
            completion?()
//            self.setNeedsLayout()
            return
        }
        
        hasImageURL = true
        
        // 4) 비동기 이미지 로드
        
//        completion?()
        
        Task {
            do {
                let img = try await StorageManager.shared.fetchPostImage(uuid: uuid)
                DispatchQueue.main.async {
                    // 5) 이미지 준비되면 스켈레톤만 지우고, 이미지만 교체
                    self.thumbnailView.hideSkeleton()
                    self.thumbnailView.image = img
                    
                    // 6) 레이아웃 필요 시 갱신
//                    self.setNeedsLayout()
//                    self.layoutIfNeeded()
//                    
                    completion?()
                }
            } catch {
                // 에러 시 스켈레톤은 숨겨 두고
                DispatchQueue.main.async {
                    self.thumbnailView.hideSkeleton()
//                    completion?()
                }
            }
        }
        
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
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
        
        ageLabel.text = "\(post.authorAgeGroup.rawValue)대"
        let ageColor: UIColor = {
            switch Int(post.authorAgeGroup.rawValue)! {
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
        sectionLabel.accessibilityLabel = "작성자 닉네임: \(post.authorNickName)"
        titleLabel.text = post.title
        titleLabel.accessibilityLabel = "제목: \(post.title)"
        subtitleLabel.text = post.content
        subtitleLabel.accessibilityLabel = "내용: \(post.content)"
        
        // 2) 날짜 포맷팅
        let date = post.createdAt.dateValue()
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        dateLabel.text = df.string(from: date)
        
        // 3) 좋아요, 댓글 수
        clapLabel.text = "\(post.likeUserID.count)"
        clapLabel.accessibilityLabel = "\(post.likeUserID.count)개의 게시물 좋아요"
//        commentLabel.text = "\(post.commentsID.count)"
//        commentLabel.accessibilityLabel = "\(post.commentsID.count)개의 게시물 댓글"
    }
    
    private func lineHeight(for textStyle: UIFont.TextStyle) -> CGFloat {
        return UIFont.preferredFont(forTextStyle: textStyle).lineHeight + 1
    }
}
