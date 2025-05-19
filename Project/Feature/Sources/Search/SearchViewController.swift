//import UIKit
//import PinLayout
//import RxSwift
//import RxCocoa
//
//// MARK: – SearchViewController
//final class SearchViewController: UIViewController, UIScrollViewDelegate {
//    private let disposeBag = DisposeBag()
////    private var selectedSubcategories: [CategoryType: [String]] = [:]
//
////    private let headerContainer = UIView()
////    
////    private let titleLabel: UILabel = {
////        let lb = UILabel()
////        lb.text = "게시물 검색하기"
////        lb.font = .systemFont(ofSize: 24, weight: .bold)
////        return lb
////    }()
//    
//    private let searchBar: UISearchBar = {
//        let sb = UISearchBar()
//        sb.placeholder = "게시물 제목을 입력해주세요."
//        sb.searchBarStyle = .minimal
//        return sb
//    }()
//    
//    private let categoryView = CategoryFilterView()
//    
//    private lazy var tableView: UITableView = {
//        let tv = UITableView()
//        tv.register(UITableViewCell.self, forCellReuseIdentifier: "feedCell")
//        tv.rx.setDelegate(self).disposed(by: disposeBag)
//        tv.showsVerticalScrollIndicator = false
//        return tv
//    }()
//    
//    // MARK: – Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        settingUI()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.pin.all()
//        
////        titleLabel.pin
////            .top(32)
////            .left(16)
////            .sizeToFit()
//        
//        searchBar.pin
//            .below(of: titleLabel).marginTop(10)
//            .horizontally(16)
//            .height(48)
//        
//        categoryView.pin
//            .below(of: searchBar).marginTop(12)
//            .horizontally()
//            .height(33)
//        
////        let h: CGFloat = 32 + 29 + 10 + 48 + 12 + 33 + 8
////        headerContainer.frame = CGRect(x: 0, y: 0,
////                                       width: tableView.frame.width,
////                                       height: h)
////        tableView.tableHeaderView = headerContainer
//    }
//    
//    private func settingUI() {
//        view.backgroundColor = .systemBackground
//        navigationController?.isNavigationBarHidden = true
//        view.addSubview(tableView)
////        [titleLabel, searchBar, categoryView].forEach { headerContainer.addSubview($0) }
////        tableView.tableHeaderView = headerContainer
//        categoryView.delegate = self
//    }
//}
//
//extension SearchViewController: CategoryFilterViewDelegate {
//    func categoryFilterView(didTapParent type: CategoryType) {
//        self.pushDetail(for: type)
//    }
//    
//    private func pushDetail(for type: CategoryType) {
//        let allCategories = categoryView.getAllCategories()
//        let selected = categoryView.getSelectedCategories()
//        
//        let vc = FilterDetailViewController(
//            type: type,
//            items: allCategories[type] ?? [],
//            selected: selected[type] ?? []
//        )
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//// MARK: – FilterDetailDelegate
//extension SearchViewController: FilterDetailDelegate {
//    func filterDetail(_ vc: FilterDetailViewController, didSelect items: [String], for category: CategoryType) {
//        categoryView.update(selected: [category: items])
//    }
//}

import UIKit
import Core

import PinLayout
import RxSwift
import RxCocoa

// MARK: - SearchViewController
final class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "게시물 제목을 입력해주세요."
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let categoryView = CategoryFilterView()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tv.rx.setDelegate(self).disposed(by: disposeBag)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.pin
            .top(view.pin.safeArea.top)
            .horizontally(16)
            .height(48)
        
        categoryView.pin
            .below(of: searchBar)
            .marginTop(8)
            .horizontally(0)
            .height(36)
        
        tableView.pin
            .below(of: categoryView)
            .horizontally(0)
            .bottom()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "게시물 검색하기" // 네비게이션 타이틀 설정

        view.addSubview(searchBar)
        view.addSubview(categoryView)
        view.addSubview(tableView)
        
        categoryView.delegate = self
    }
    
    private func binding() {
        let categoriesObservable = Observable.deferred {
            let latest = self.categoryView
                             .getSelectedCategories()
                             .values
                             .flatMap { $0 }
            return .just(latest)
        }.distinctUntilChanged()
        
        searchBar.rx.text.orEmpty
          .debounce(.milliseconds(300), scheduler: MainScheduler.instance)    // 불필요한 호출 줄이기
          .distinctUntilChanged()                                           // 같은 텍스트 중복 방지
          .withLatestFrom(categoriesObservable) { query, cats in (query, cats) }
          .flatMapLatest { query, cats -> Observable<[Post]> in
              // 2) async/await fetchPosts를 Observable로 래핑
              Observable.create { observer in
                  Task {
                      do {
                          let posts = try await FireStoreManager.shared.fetchPosts(withTitle: query, categories: cats)
                          observer.onNext(posts)
                          observer.onCompleted()
                      } catch {
                          observer.onError(error)
                      }
                  }
                  return Disposables.create()
              }
          }
          .observe(on: MainScheduler.instance)  // UI 바인딩은 메인스레드
          // 3) 결과를 테이블뷰에 바인딩
          .bind(to: tableView.rx.items(
              cellIdentifier: MainTableViewCell.reuseIdentifier,
              cellType: MainTableViewCell.self
          )) { _, post, cell in
              cell.configure(with: post)
              {
                  self.tableView.beginUpdates()
                  self.tableView.endUpdates()
              }
          }
          .disposed(by: disposeBag)
    }
}

// MARK: - CategoryFilterViewDelegate
extension SearchViewController: CategoryFilterViewDelegate {
    func categoryFilterView(didTapParent type: CategoryType) {
        self.pushDetail(for: type)
    }
    
    private func pushDetail(for type: CategoryType) {
        let allCategories = categoryView.getAllCategories()
        let selected = categoryView.getSelectedCategories()
        
        let vc = FilterDetailViewController(
            type: type,
            items: allCategories[type] ?? [],
            selected: selected[type] ?? []
        )
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FilterDetailDelegate
extension SearchViewController: FilterDetailDelegate {
    func filterDetail(_ vc: FilterDetailViewController, didSelect items: [String], for category: CategoryType) {
        categoryView.update(selected: [category: items])
    }
}

extension SearchViewController: UIScrollViewDelegate { }
