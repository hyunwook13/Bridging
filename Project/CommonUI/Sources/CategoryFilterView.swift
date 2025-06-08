//
//  CategoryFilterView.swift
//  Bridging
//
//  Created by 이현욱 on 4/28/25.
//

import UIKit

struct ChipItem: Hashable {
    let isParent: Bool
    let type: CategoryType
    let title: String
}

// MARK: – Subcategory 모델
public struct SubCategory {
    public let title: String
    public var isSelected: Bool
    public init(title: String, isSelected: Bool = false) {
        self.title = title
        self.isSelected = isSelected
    }
}

public enum CategoryType: String, CaseIterable {
    case age    = "연령대"
    case gender = "성별"
    case topic  = "카테고리"
}

// MARK: – Delegate 프로토콜
public protocol CategoryFilterViewDelegate: AnyObject {
    func categoryFilterView(didTapParent type: CategoryType)
}

// MARK: – UIView 서브클래스
public final class CategoryFilterView: UIView {
    // 외부에 노출할 델리게이트
    public weak var delegate: CategoryFilterViewDelegate?
    
    // 내부 데이터
    private let allSubcategories: [CategoryType: [SubCategory]]
    private var selectedSubcategories: [CategoryType: [String]] = [:]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(ChipCell.self, forCellWithReuseIdentifier: ChipCell.reuseID)
        cv.delegate = self
        return cv
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, ChipItem> = {
        let ds = UICollectionViewDiffableDataSource<Int, ChipItem>(collectionView: collectionView) { [weak self] cv, idx, item in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ChipCell.reuseID, for: idx) as! ChipCell
            cell.configure(title: item.title, isParent: item.isParent) { [weak self] in
                guard let self = self else { return }
            }
            return cell
        }
        return ds
    }()
    
    // MARK: – Init
    public init(all: [CategoryType: [SubCategory]] = [
        .age:    ["10대","20대","30대","40대","50대","60대"].map { SubCategory(title: $0) },
        .gender: ["남성","여성"].map    { SubCategory(title: $0) },
        .topic:  ["사회","경제","정치","문화","기술","스포츠","자유"].map { SubCategory(title: $0) },
    ]) {
        self.allSubcategories = all
        super.init(frame: .zero)
        setup()
        reloadData(animated: false)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.pin.all()
    }
    
    public func preSelected(categories: [String]) {
        let merged = allSubcategories.mapValues { _ in categories }
        self.update(selected: merged)
    }
    
    public func update(selected newSelections: [CategoryType: [String]]) {
        // 1) 기존 선택 상태를 가져온 뒤
        for (type, items) in newSelections {
            // 2) 새로 전달된 items만 기존에 append
            var current = selectedSubcategories[type] ?? []
            for title in items where !current.contains(title) {
                current.append(title)
            }
            selectedSubcategories[type] = current
        }
        // 3) 병합된 상태로 UI 업데이트
        reloadData(animated: true)
    }
    
    public func getSelectedCategories() -> [CategoryType: [String]] {
        return selectedSubcategories
    }
    
    public func getAllCategories() -> [CategoryType: [SubCategory]] {
        return allSubcategories
    }
    
    // MARK: – 내부 로직
    private func setup() {
        addSubview(collectionView)
        collectionView.dataSource = dataSource
    }
    
    private func reloadData(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChipItem>()
        snapshot.appendSections([0])
        let items = CategoryType.allCases.flatMap { type -> [ChipItem] in
            var arr = [ ChipItem(isParent: true,  type: type, title: type.rawValue) ]
            (selectedSubcategories[type] ?? []).forEach {
                arr.append( ChipItem(isParent: false, type: type, title: $0) )
            }
            return arr
        }
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func deselectSubcategory(title: String) {
        for (type, children) in selectedSubcategories {
            if let idx = children.firstIndex(of: title) {
                selectedSubcategories[type]?.remove(at: idx)
                break
            }
        }
        reloadData(animated: true)
    }
}

// MARK: – UICollectionViewDelegateFlowLayout & Selection
extension CategoryFilterView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        if item.isParent {
            delegate?.categoryFilterView(didTapParent: item.type)
        } else {
            deselectSubcategory(title: item.title)
        }
    }
    
    public func collectionView(
        _ cv: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return .zero }
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let textWidth = (item.title as NSString).size(withAttributes: [.font: font]).width
        let padding: CGFloat = 16 * 2
        let subCellXMark: CGFloat = item.isParent ? 0 : 4
        return CGSize(width: ceil(textWidth + padding + subCellXMark), height: 32)
    }
}
