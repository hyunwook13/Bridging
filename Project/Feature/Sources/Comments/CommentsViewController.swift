////
////  CommentsViewController.swift
////  Bridging
////
////  Created by 이현욱 on 4/30/25.
////
//
//import UIKit
//
//import PinLayout
//import RxSwift
//import RxCocoa
//
//// MARK: - Model
//struct Comment {
//    let nickname: String
//    let content: String
//    let date: Date
//}
//
//// MARK: - CommentCell
//final class CommentCell: UITableViewCell {
//    static let reuseIdentifier = "CommentCell"
//
//    private let nicknameLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .systemFont(ofSize: 14, weight: .bold)
//        lbl.textColor = .label
//        return lbl
//    }()
//    private let contentLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .systemFont(ofSize: 14)
//        lbl.textColor = .label
//        lbl.numberOfLines = 0
//        return lbl
//    }()
//    private let dateLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .systemFont(ofSize: 12)
//        lbl.textColor = .secondaryLabel
//        return lbl
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(nicknameLabel)
//        contentView.addSubview(contentLabel)
//        contentView.addSubview(dateLabel)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let padding: CGFloat = 16
//        nicknameLabel.pin
//            .top(padding)
//            .left(padding)
//            .right(padding)
//            .sizeToFit()
//        
//        contentLabel.pin
//            .below(of: nicknameLabel)
//            .marginTop(4)
//            .left(padding)
//            .right(padding)
//            .sizeToFit(.width)
//
//        dateLabel.pin
//            .below(of: contentLabel)
//            .marginTop(4)
//            .left(padding)
//            .sizeToFit()
//
//        // adjust cell height
//        let h = dateLabel.frame.maxY + padding
//        contentView.frame.size.height = h
//    }
//    
//    func configure(with comment: Comment) {
//        nicknameLabel.text = comment.nickname
//        contentLabel.text = comment.content
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        dateLabel.text = formatter.string(from: comment.date)
//    }
//}
//
//// MARK: - CommentsViewController
//final class CommentsViewController: UIViewController {
//    private let disposeBag = DisposeBag()
//    
//    // Header: input area
//    private let headerView = UIView()
//    private let commentInputTextView: UITextView = {
//        let tv = UITextView()
//        tv.font = .systemFont(ofSize: 14)
//        tv.layer.borderColor = UIColor.separator.cgColor
//        tv.layer.borderWidth = 1
//        tv.layer.cornerRadius = 8
//        return tv
//    }()
//    private let completeButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("완료", for: .normal)
//        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
//        btn.isEnabled = false
//        return btn
//    }()
//    
//    private let tableView = UITableView(frame: .zero, style: .plain)
//
//    // Data
//    private let comments = BehaviorRelay<[Comment]>(value: [])
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupTableView()
//        setupHeaderView()
//        bindRx()
//    }
//    
//    private func setupTableView() {
//        view.addSubview(tableView)
//        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
//        tableView.tableHeaderView = headerView
//        tableView.separatorStyle = .none
//    }
//    
//    private func setupHeaderView() {
//        headerView.addSubview(commentInputTextView)
//        headerView.addSubview(completeButton)
//        // set initial frame; will adjust in layout
//        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 120)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.pin.all(view.pin.safeArea)
//        
//        // layout header subviews
//        let padding: CGFloat = 16
//        completeButton.pin
//            .top(padding)
//            .right(padding)
//            .sizeToFit()
//        
//        commentInputTextView.pin
//            .top(padding)
//            .left(padding)
//            .right(to: completeButton.edge.left).marginRight(8)
//            .height(completeButton.frame.height)
//
//        // adjust headerView height
//        let h = completeButton.frame.maxY + padding
//        headerView.frame.size.height = h
//        tableView.tableHeaderView = headerView
//    }
//    
//    private func bindRx() {
//        // enable complete button when text non-empty
//        commentInputTextView.rx.text.orEmpty
//            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
//            .bind(to: completeButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
//        // add comment on tap
//        completeButton.rx.tap
//            .withLatestFrom(commentInputTextView.rx.text.orEmpty)
//            .map { text -> Comment in
//                return Comment(nickname: "Me", content: text, date: Date())
//            }
//            .subscribe(onNext: { [weak self] comment in
//                guard let self = self else { return }
//                var arr = self.comments.value
//                arr.insert(comment, at: 0)
//                self.comments.accept(arr)
//                self.commentInputTextView.text = ""
//                self.view.setNeedsLayout()
//            })
//            .disposed(by: disposeBag)
//        
//        // bind comments to table
//        comments.asObservable()
//            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier,
//                                          cellType: CommentCell.self)) { _, comment, cell in
//                cell.configure(with: comment)
//            }
//            .disposed(by: disposeBag)
//    }
//}

import UIKit
import PinLayout
import RxSwift
import RxCocoa

// MARK: - Model
struct Comment {
    let nickname: String
    let content: String
    let date: Date
}

// MARK: - CommentCell
final class CommentCell: UITableViewCell {
    static let reuseIdentifier = "CommentCell"

    private let nicknameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .bold)
        lbl.textColor = .label
        return lbl
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
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
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
        nicknameLabel.pin
            .top(padding)
            .left(padding)
            .right(padding)
            .sizeToFit()
        
        contentLabel.pin
            .below(of: nicknameLabel)
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
    
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.nickname
        contentLabel.text = comment.content
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: comment.date)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        let height = dateLabel.frame.maxY
        return CGSize(width: size.width, height: height)
    }
}

// MARK: - CommentsViewController
final class CommentsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // Header: input area
    private let headerView = UIView()
    private let commentInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.layer.borderColor = UIColor.separator.cgColor
        
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        return tv
    }()
    private let completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isEnabled = false
        return btn
    }()
    
    private let seperateView = UIView()
    private let seperateView2 = UIView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)

    // Data
    private let comments = BehaviorRelay<[Comment]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // 네비게이션 바 설정
        title = "댓글"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeTapped))
//        navigationController?.isNavigationBarHidden = false
        isModalInPresentation = true

        setupTableView()
        setupHeaderView()
        bindRx()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.tableHeaderView = headerView
        tableView.estimatedRowHeight = 10
        tableView.separatorStyle = .none
    }
    
    private func setupHeaderView() {
        headerView.addSubview(commentInputTextView)
        headerView.addSubview(completeButton)
        headerView.addSubview(seperateView)
        headerView.addSubview(seperateView2)
        
        seperateView.backgroundColor = .gray
        seperateView2.backgroundColor = .gray
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 120)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all(view.pin.safeArea)
        
        // Header layout
        let padding: CGFloat = 16
        completeButton.pin
            .top(padding)
        
            .right(padding)
            .bottom(padding)
            .width(60)
//            .sizeToFit()
        commentInputTextView.pin
            .top(padding)
            .left(padding)
            .bottom(padding)
            .right(to: completeButton.edge.left).marginRight(padding)
//            .height(completeButton.frame.height)
        seperateView2.pin
            .height(1)
            .top().left().right()
        
        seperateView.pin
            .height(1)
            .left().bottom().right()
        
        let h = completeButton.frame.maxY + padding
        headerView.frame.size.height = h
        tableView.tableHeaderView = headerView
    }
    
    private func bindRx() {
        // enable complete button when non-empty
        commentInputTextView.rx.text.orEmpty
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // add comment
        completeButton.rx.tap
            .withLatestFrom(commentInputTextView.rx.text.orEmpty)
            .map { text in Comment(nickname: "Me", content: text, date: Date()) }
            .subscribe(onNext: { [weak self] comment in
                guard let self = self else { return }
                var arr = self.comments.value
                arr.insert(comment, at: 0)
                self.comments.accept(arr)
                self.commentInputTextView.text = ""
                self.view.setNeedsLayout()
            })
            .disposed(by: disposeBag)
        
        // bind to table
        comments.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier,
                                          cellType: CommentCell.self)) { _, comment, cell in
                cell.configure(with: comment)
            }
            .disposed(by: disposeBag)
    }
}
