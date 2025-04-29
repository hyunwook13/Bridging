//
//  MainViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import UIKit

import PinLayout
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let postsSubject = PublishSubject<[Post]>()
    
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
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = .zero
        tv.estimatedRowHeight = 10
        tv.showsHorizontalScrollIndicator = true
        tv.delegate = self
        tv.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return tv
    }()
    
    private let seperateView = UIView()
    
    private let floatingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 28
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        binding()
        Task {
            do {
                let data = try await FireStore.shared.getAllPosts()
                postsSubject.onNext(data)
            } catch {
                print("error: ", error.localizedDescription)
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        headerView.addSubview(appImageView)
        headerView.addSubview(searchButton)
        headerView.clipsToBounds = true
        
        view.addSubview(tableView)
        view.addSubview(seperateView)
        view.addSubview(floatingButton)
        
        seperateView.backgroundColor = UIColor.init(named: "customGray")
    }
    
    private func binding() {
        searchButton.rx.tap
            .bind {
                let vc = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        floatingButton.rx.tap
            .bind {
                
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Post.self)
            .bind { post in
                
            }.disposed(by: disposeBag)
        
        postsSubject
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.reuseIdentifier, cellType: MainTableViewCell.self)) { _, post, cell in
                cell.configure(with: post)
            }.disposed(by: disposeBag)
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The UITableView will call the cell's sizeThatFit() method to compute the height.
        // WANRING: You must also set the UITableView.estimatedRowHeight for this to work.
        return UITableView.automaticDimension
    }
}
