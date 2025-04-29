////
////  Detail.swift
////  Bridging
////
////  Created by 이현욱 on 4/28/25.
////
//
//import UIKit
//
//import PinLayout
//import RxSwift
//import RxCocoa
//
//// MARK: - FilterDetailViewController
//protocol FilterDetailDelegate: AnyObject {
//    func filterDetail(_ vc: FilterDetailViewController, didSelect items: [String], for category: CategoryType)
//}
//
//final class FilterDetailViewController: UIViewController {
//    private let disposeBag = DisposeBag()
//    private let category: CategoryType
//    private var items: [SubCategory]
//    private var selected: [String]
//    weak var delegate: FilterDetailDelegate?
//    
//    // MARK: - Custom Header
////    private let headerView = UIView()
////    private let backButton: UIButton = {
////        let btn = UIButton(type: .system)
////        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
////        btn.tintColor = .label
////        return btn
////    }()
////    private let doneButton: UIButton = {
////        let btn = UIButton(type: .system)
////        btn.setTitle("완료", for: .normal)
////        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
////        btn.tintColor = .systemBlue
////        return btn
////    }()
//    private let titleLabel = UILabel()
//    
//    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
//    
//    init(type: CategoryType, items: [SubCategory], selected: [String]) {
//        self.category = type
//        self.items = items
//        self.selected = selected
//        super.init(nibName: nil, bundle: nil)
//        titleLabel.text = "\(type.rawValue) 선택"
//        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
//        titleLabel.textAlignment = .center
//    }
//    required init?(coder: NSCoder) { fatalError() }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
////        navigationController?.isNavigationBarHidden = true
//        
//        // add subviews
//        view.addSubview(headerView)
//        headerView.addSubview(backButton)
//        headerView.addSubview(titleLabel)
//        headerView.addSubview(doneButton)
//        view.addSubview(tableView)
//        
//        // table view setup
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        // actions
//        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
//        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // calculate safe area and header height
//        let topInset = view.safeAreaInsets.top
//        let headerHeight: CGFloat = topInset + 44
//        
//        // header
//        headerView.pin
//            .top()
//            .horizontally()
//            .height(headerHeight)
//        headerView.backgroundColor = .systemBackground
//        
//        // back button
//        backButton.pin
//            .top(topInset + (44 - 24) / 2)
//            .left(16)
//            .size(24)
//        
//        // done button
//        doneButton.pin
//            .top(topInset + (44 - 28) / 2)
//            .right(16)
//            .sizeToFit()
//        
//        // title label
//        let titleX = backButton.frame.maxX + 8
//        let titleWidth = view.bounds.width - titleX - doneButton.bounds.width - 8 - 16
//        titleLabel.pin
//            .top(topInset + (44 - 24) / 2)
//            .left(titleX)
//            .width(titleWidth)
//            .height(24)
//        
//        // table view
//        tableView.pin
//            .below(of: headerView)
//            .left()
//            .right()
//            .bottom()
//    }
//    
//    @objc private func backTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc private func doneTapped() {
//        delegate?.filterDetail(self, didSelect: selected, for: category)
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//// MARK: – UITableViewDataSource, UITableViewDelegate
//extension FilterDetailViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let item = items[indexPath.row]
//        cell.textLabel?.text = item.title
//        cell.accessoryType = selected.contains(item.title) ? .checkmark : .none
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let title = items[indexPath.row].title
//        if let idx = selected.firstIndex(of: title) { selected.remove(at: idx) }
//        else { selected.append(title) }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//}

import UIKit
import PinLayout
import RxSwift
import RxCocoa

// MARK: - FilterDetailViewController
protocol FilterDetailDelegate: AnyObject {
    func filterDetail(_ vc: FilterDetailViewController, didSelect items: [String], for category: CategoryType)
}

final class FilterDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let category: CategoryType
    private var items: [SubCategory]
    private var selected: [String]
    weak var delegate: FilterDetailDelegate?

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(type: CategoryType, items: [SubCategory], selected: [String]) {
        self.category = type
        self.items = items
        self.selected = selected
        super.init(nibName: nil, bundle: nil)
        self.title = "\(type.rawValue) 선택" // Navigation bar 타이틀 설정
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // 완료 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all(view.pin.safeArea)
    }
    
    @objc private func doneTapped() {
        delegate?.filterDetail(self, didSelect: selected, for: category)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FilterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = selected.contains(item.title) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = items[indexPath.row].title
        if let idx = selected.firstIndex(of: title) {
            selected.remove(at: idx)
        } else {
            selected.append(title)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
