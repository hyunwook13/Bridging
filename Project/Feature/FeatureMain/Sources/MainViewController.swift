//
//  MainViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import UIKit
import Core
import Domain
import Common
import CommonUI

import PinLayout
import RxSwift
import RxCocoa
import SkeletonView

public final class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let postsRelay = BehaviorRelay<[Post]>(
        value: [] //Array(repeating: Post.empty, count: 5)
    )
    private let loadNextPageTrigger = PublishSubject<Void>()
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private var isFirstLoad = true
    
    // MARK: – UI 요소
    private let headerView = UIView()
    
    private let appImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "AppImage"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    private let settingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = .zero
//        tv.estimatedRowHeight = 200
        tv.showsVerticalScrollIndicator = false
        //        tv.rx.setDataSource(self).disposed(by: disposeBag)
        tv.rx.setDelegate(self).disposed(by: disposeBag)
        tv.rowHeight = UITableView.automaticDimension
        //        tv.rx.setDataSource(self).disposed(by: disposeBag)
        
        tv.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return tv
    }()
    
    private let seperateView = UIView()
    
    let categoryView = CategoryFilterView()
    
    private let floatingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 28
//        btn.accessibilityLabel = "글 작성버튼"
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    // MARK: – Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        binding()
        self.loadNextPageTrigger.onNext(())
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navBarH = navigationController?.navigationBar.frame.maxY ?? view.safeAreaInsets.top
        navigationController?.isNavigationBarHidden = true
        
        headerView.pin
            .top()
            .horizontally()
            .height(navBarH)
        
        seperateView.pin
            .top(to: headerView.edge.bottom)
            .left()
            .right()
            .height(1)
        
        appImageView.pin
            .left(16)
            .size(66)
            .bottom()
            .margin(-6)
        
        searchButton.pin
            .right(8)
            .size(44)
            .bottom()
            .margin(4)
        
        settingButton.pin
            .right(to: searchButton.edge.left)
//            .marginRight(8)
            .size(44)
            .vCenter(to: searchButton.edge.vCenter)
        
        tableView.pin
            .below(of: headerView)
            .horizontally(16)
            .bottom()
        
        floatingButton.pin
            .size(56)
            .bottom(view.pin.safeArea).margin(24)
            .right(view.pin.safeArea).margin(24)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func settingUI() {
        view.isSkeletonable = true
        view.backgroundColor = .systemBackground
        seperateView.backgroundColor = UIColor.init(named: "customGray")
        
        view.addSubview(headerView)
        headerView.addSubview(appImageView)
        headerView.addSubview(settingButton)
        headerView.addSubview(searchButton)
        headerView.clipsToBounds = true
        
        view.addSubview(tableView)
        view.addSubview(seperateView)
        view.addSubview(floatingButton)
    }
    
    private func binding() {
//        searchButton.rx.tap
//            .bind {
//                let vc = SearchViewController()
//                vc.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }.disposed(by: disposeBag)
//        
//        floatingButton.rx.tap
//            .requireLogin()
//            .bind {
//                let vc = PostComposeViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//            }.disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(Post.self)
//            .filter { $0.isTemporaryFlag }
//            .bind { post in
//                let vc = PostDetailViewController(post: post)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .filter { [weak self] _, idx in
                idx.row == self?.postsRelay.value.count ?? 0 - 1
                && idx.row % 10 == 0
            }
            .map { _ in () }
            .bind(to: loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        FireStoreManager.shared.newPostStream
            .subscribe(onNext: { [weak self] newPost in
                guard let self = self else { return }
                var current = self.postsRelay.value
                // 중복 방지
                
                if let post = newPost, !current.contains(where: { $0.id == newPost?.id }) {
                    // 새 글은 앞에 삽입
                    current.insert(post, at: 0)
                    self.postsRelay.accept(current)
                }
            })
            .disposed(by: disposeBag)
        
        loadNextPageTrigger
            .filter { !self.isLoading.value }
            .do(onNext: { _ in
                self.isLoading.accept(true)
                self.tableView.showGradientSkeleton()
            })
            .flatMapLatest { _ in
                FireStoreManager.shared.fetchNextPage().asObservable()
            }
            .subscribe(onNext: { [weak self] newPosts in
                guard let self = self else { return }
                
                if self.isFirstLoad {
                    self.postsRelay.accept(newPosts)
                    self.isFirstLoad = false
                } else {
                    self.postsRelay.accept(self.postsRelay.value + newPosts)
                }
                
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                print("페이지 로드 실패:", error)
                self?.isLoading.accept(false)
                HapticManager.shared.notify(.error)
            })
            .disposed(by: disposeBag)
        
        postsRelay
//            .do(onNext: { _ in
//                if self.tableView.sk.isSkeletonActive {
//                    self.tableView.hideSkeleton(transition: .crossDissolve(0.25))
//                }
//            })
//            .flatMapLatest { posts in
//                Observable.just(posts)
//                    .delay(.milliseconds(250), scheduler: MainScheduler.instance)
//            }
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.reuseIdentifier, cellType: MainTableViewCell.self)) { _, post, cell in
                cell.configure(with: post)
                {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }.disposed(by: disposeBag)
    }
    //
    //    func refreshAll() {
    //        service.reset()
    //        postsRelay.accept([])
    //        loadNextTrigger.onNext(())
    //    }
    
    
}


extension MainViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell
    //
    //        else { return 170 }
    //
    //        guard let posts = try? postsSubject.value() else { print("postS"); return 170}
    //
    //        let post = posts[indexPath.row]
    //        let width = tableView.bounds.width
    //        cell.configure(with: post)
    //
    //        let fittingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
    //        return cell.sizeThatFits(fittingSize).height
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let posts = (try? postsSubject.value()) ?? []
    //        let post  = posts[indexPath.row]
    //        let width = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
    //        return MainTableViewCell.height(for: post, width: width)
    //    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return UITableView.automaticDimension
    //    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let posts = postsRelay.value
        let post = posts[indexPath.row]
        let width = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
        
        // 로딩 중이면 Skeleton 높이, 아니면 실제 데이터 높이
        if true { //*!post.isTemporaryFlag*/ {
            return MainTableViewCell.skeletonHeight(width: width)
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else { return MainTableViewCell.height(for: post, width: width)}
            
            cell.configure(with: post)
            cell.layout()
            let targetSize = CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude)
            return cell.sizeThatFits(targetSize).height
        }
    }
}
