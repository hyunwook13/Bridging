//
//  PostDetailViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/30/25.
//
//

import UIKit
import Core

import PinLayout
import RxSwift
import RxCocoa

final class PostDetailViewController: UIViewController {
    
    private var post: Post!
    private var votes: [Vote] = []
    // MARK: - UI Elements
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .title3)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let deleteBtn: UIButton = {
        let btn = UIButton(type: .system)              // ➊
        let image = UIImage(systemName: "trash.fill")  // ➋
        btn.setImage(image, for: .normal)
        btn.tintColor = .systemRed                     // ➌
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let editBtn: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(systemName: "pencil")               // SF Symbol 연필 아이콘
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .footnote)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()

    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = .preferredFont(forTextStyle: .body)
        tv.textColor = .label
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()

    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.isHidden = true
        return iv
    }()

    private let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .systemRed
        return btn
    }()

    private let commentCountLabel: UIButton = {
        let lbl = UIButton(type: .system)
        lbl.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        lbl.tintColor = .secondaryLabel
        return lbl
    }()

    private let commentBoxView: UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor.systemGray6
        v.layer.cornerRadius = 8
        return v
    }()

    private let previewCommentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        configure(with: post)
    }
    
    deinit {
        print("deinit PostDetailViewController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        asd()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Pin scrollView to safe area
        scrollView.pin.all(view.pin.safeArea)
        // ContentView matches scrollView width
        contentView.pin
            .topLeft()
            .width(of: scrollView)

        // Layout subviews inside contentView
        let padding: CGFloat = 16
        // Title
        titleLabel.pin
            .top(padding)
            .horizontally(padding)
            .sizeToFit(.width)
        // Author
        authorLabel.pin
            .below(of: titleLabel)
            .marginTop(4)
            .left(to: titleLabel.edge.left)
            .sizeToFit()
        // Separator
        separatorView.pin
            .below(of: authorLabel)
            .marginTop(4)
            .horizontally(padding)
            .height(1)
        // Content text
        contentTextView.pin
            .below(of: separatorView)
            .marginTop(8)
            .horizontally(padding)
            .sizeToFit(.width)
        // Image under text
        if !postImageView.isHidden {
            postImageView.pin
                .below(of: contentTextView)
                .marginTop(8)
                .horizontally(padding)
                .height(200)
        }
        // Like and comment count
        let likeTop = postImageView.isHidden ? contentTextView.frame.maxY : postImageView.frame.maxY
        likeButton.pin
            .top(likeTop + 12)
            .left(padding)
            .size(24)
        commentCountLabel.pin
            .vCenter(to: likeButton.edge.vCenter)
            .after(of: likeButton)
            .marginLeft(8)
            .sizeToFit()
        // Comment preview box
        commentBoxView.pin
            .below(of: likeButton)
            .marginTop(12)
            .horizontally(padding)
                previewCommentLabel.pin
                    .all(padding)
                    .sizeToFit(.width)
        commentBoxView.pin.height(previewCommentLabel.frame.maxY + padding)

        // Set contentView height for scroll
        let contentHeight = commentBoxView.frame.maxY + padding
        contentView.pin.height(contentHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
    
    private func asd() {
                FireStoreManager.shared.fetchVotes(postUUID: post.uuid)
                    .asObservable()
                    .bind {
                        self.votes = $0
                    }
                    .disposed(by: disposeBag)
    }

    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: deleteBtn), UIBarButtonItem(customView: editBtn)]
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, authorLabel, separatorView,
         contentTextView, postImageView, likeButton,
         commentCountLabel, commentBoxView, previewCommentLabel].forEach {
            if $0 === previewCommentLabel {
                commentBoxView.addSubview(previewCommentLabel)
            } else {
                contentView.addSubview($0)
            }
        }
        
        title = "게시물 상세"
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Configuration
    func configure(with post: Post) {
        titleLabel.text = post.title
        authorLabel.text = "by \(post.authorNickName)"
        contentTextView.text = post.content
        likeButton.setImage(
            UIImage(systemName: post.likeUserID.isEmpty ? "heart" : "heart.fill"),
            for: .normal)
//        commentCountLabel.setTitle("댓글 \(post.commentsID.count)개", for: .normal)
        if let lastComment = post.lastComment {
            previewCommentLabel.text = lastComment
        } else {
            previewCommentLabel.text = "댓글이 없습니다."
        }
        
        // Show image if URL present
        if let imageURL = post.imageURL, !imageURL.isEmpty {
            postImageView.isHidden = false
            
            // load image async here, e.g. via StorageManager
            Task {
                do {
                    let image = try await StorageManager.shared.fetchPostImage(uuid: post.imageURL)
                    DispatchQueue.main.async { [weak self] in
                        self?.postImageView.image = image
//                        self.view.setNeedsLayout()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            postImageView.isHidden = true
        }
    }
    
    func bind() {
        likeButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .requireLogin()
            .bind {
//                FireStoreManager.shared.
            }.disposed(by: disposeBag)
        
        editBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .requireLogin()
            .bind {
                let co = PostComposeViewController(post: self.post)
                self.navigationController?.pushViewController(co, animated: true)
            }.disposed(by: disposeBag)
        
        AuthManager.shared.userRelay
            .compactMap { $0 }
            .map { [weak self] in
                $0.uid != self?.post.createdUserID
            }
            .bind {
                self.deleteBtn.isHidden = $0
                self.editBtn.isHidden = $0
            }
            .disposed(by: disposeBag)
        
        deleteBtn.rx.tap
            .requireLogin()
            .compactMap { self.post.uuid }
            .flatMapLatest {  id -> Single<Void> in
                return FireStoreManager.shared.removePost(with: id)
            }
            .subscribe(
                onNext: { _ in
                    print("삭제 완료 🎉")
                    self.navigationController?.popViewController(animated: true)
                },
                onError: { error in
                    print("삭제 실패:", error.localizedDescription)
                    HapticManager.shared.notify(.error)
                })
            .disposed(by: disposeBag)
        
        Observable.merge(commentBoxView.rx.tap.asObservable(), commentCountLabel.rx.tap.asObservable())
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { _ in
                var asd = self.post!
                asd.votes = self.votes
                
                let vc = CommentsViewController(post: asd)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }.disposed(by: disposeBag)
    }
}
