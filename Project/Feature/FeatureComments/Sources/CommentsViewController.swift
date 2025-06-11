//  CommentsViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/30/25.

import UIKit
import Domain
import Common
import Core

//import FirebaseFirestore
import RxSwift
import RxCocoa
import PinLayout

protocol SelecteOpinionDelegate: AnyObject {
    func selectedOpinion(_ opinion: VoteType)
}

// MARK: - CommentsViewController
public final class CommentsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var post: Post
    private var voteType: VoteType?

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
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["전체", "찬성", "반대"])
        control.selectedSegmentIndex = 0
        return control
    }()

//    private let seperateView = UIView()
    private let seperateView2 = UIView()

    private let tableView = UITableView(frame: .zero, style: .plain)

    // Data
    private let comments = BehaviorRelay<[Comment]>(value: [])
    private var allComments: [Comment] = []

    init(post: Post) {
        self.post = post
//        self.voteType = post.votes.first(where: { $0.uuid == AuthManager.shared.userRelay.value?.uid })?.vote
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "댓글"

        edgesForExtendedLayout = []
        setupTableView()
        setupHeaderView()
        bindRx()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FireStoreManager.shared.fetchComments(with: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] fetched in
                self?.allComments = fetched
                self?.filterComments()
            }).disposed(by: disposeBag)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
    }

    private func setupHeaderView() {
        headerView.addSubview(segmentControl)
        headerView.addSubview(commentInputTextView)
        headerView.addSubview(completeButton)
//        headerView.addSubview(seperateView)
        headerView.addSubview(seperateView2)

//        seperateView.backgroundColor = .gray
        seperateView2.backgroundColor = .gray

        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 160)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all(view.pin.safeArea)

        let padding: CGFloat = 16

        segmentControl.pin.top(padding).left(padding).right(padding).height(30)
        
        completeButton.pin.top(to: segmentControl.edge.bottom).marginTop(padding).right(padding).bottom(padding).width(60)
        commentInputTextView.pin.top(to: segmentControl.edge.bottom).marginTop(padding).left(padding).right(to: completeButton.edge.left).marginRight(padding).bottom(padding)

        seperateView2.pin.height(1).left().bottom().right()

        headerView.frame.size.height = completeButton.frame.maxY + padding
        tableView.tableHeaderView = headerView
    }

    private func bindRx() {
        commentInputTextView.rx.text.orEmpty
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .subscribe(on: MainScheduler.instance)
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)

        segmentControl.rx.selectedSegmentIndex
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.filterComments()
            }).disposed(by: disposeBag)

        completeButton.rx.tap
            .requireLogin()
            .withLatestFrom(commentInputTextView.rx.text.orEmpty)
            .withLatestFrom(AuthManager.shared.userRelay) { text, user in (text, user) }
            .withLatestFrom(AuthManager.shared.profileRelay) { text, user in
                return Comment(
                    uuid: UUID().uuidString,
                    authorID: text.1!.uid,
                    createdAt: Date(),
                    authorAgeGroup: user!.ageGroup,
                    authorNickName: user!.nickname,
                    gender: user!.gender,
                    content: text.0,
                    vote: self.voteType ?? .agree
                )
            }.flatMapLatest {
                FireStoreManager.shared.saveComment(with: self.post.id, comment: $0).asObservable()
            }.subscribe (onNext: { [weak self] in
                self?.commentInputTextView.text = ""
                self?.allComments.append($0)
                self?.filterComments()
            }).disposed(by: disposeBag)

        comments.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier,
                                         cellType: CommentCell.self)) { _, comment, cell in
                cell.configure(with: comment)
            }.disposed(by: disposeBag)
    }

    private func filterComments() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch segmentControl.selectedSegmentIndex {
            case 1:
                comments.accept(allComments.filter { $0.vote == .agree })
            case 2:
                comments.accept(allComments.filter { $0.vote == .disagree })
            default:
                comments.accept(allComments)
            }
        }
    }
}

extension CommentsViewController: SelecteOpinionDelegate {
    func selectedOpinion(_ opinion: VoteType) {
        voteType = opinion
        FireStoreManager.shared.saveVote(postUUID: post.id, type: opinion)
            .subscribe {
                HapticManager.shared.notify(.success)
            } onError: { error in
                BridgingLogger.logEvent("fail_to_save_vote", parameters: ["error":error.localizedDescription])
                HapticManager.shared.notify(.error)
            }.disposed(by: disposeBag)
    }
}
