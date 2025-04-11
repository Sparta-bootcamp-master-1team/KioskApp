//
//  CategoryCollectionView.swift
//  KioskApp
//
//  Created by 조선우 on 4/8/25.
//

import UIKit
import SnapKit

protocol CoffeeCategoryCollectionViewDelegate: AnyObject {
    func categoryButtonDidTap(index: Int)
}

class CoffeeCategoryCollectionView: UIView {
    
    weak var delegate: CoffeeCategoryCollectionViewDelegate?
    
    // 메뉴 카테고리 배열
    private let categories = ["추천메뉴", "커피(ICED)", "커피(HOT)", "음료(ICED)", "음료(HOT)", "디저트"]
    
    // MARK: - UICollectionView
    
    // 메뉴 카테고리를 위한 UICollectionView 생성
    private(set) lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return view
    }()
    
    private var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    var buttonBackgroundColor: UIColor = #colorLiteral(red: 0.3039717376, green: 0.1641474366, blue: 0.07612364739, alpha: 1) { // 기본값은 메가커피 색상으로 지정
        didSet {
            categoryCollectionView.reloadData() // 브랜드 색상 변경 시 전체 리로드
            selectRecommendedMenu() // 브랜드 변경 시 첫번째 셀(추천메뉴) 선택 유지
        }
    }
    
    
    // MARK: - init 및 UI 설정
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 추천메뉴 셀 선택 메서드
    func selectRecommendedMenu() {
        let indexPath = IndexPath(item: 0, section: 0)
        selectedIndex = indexPath
        categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
//        categoryCollectionView.scrollToItem(at: indexPath, at: [], animated: false)
        categoryCollectionView.setContentOffset(.zero, animated: false)
        categoryCollectionView.reloadData()
        
        delegate?.categoryButtonDidTap(index: 0) // 위임자에게 선택 알림
    }
    
    //MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if categoryCollectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            selectRecommendedMenu() // 초기값으로 첫번째 셀(추천메뉴) 설정
        }
    }
}

// MARK: - UICollectionView DataSource

extension CoffeeCategoryCollectionView: UICollectionViewDataSource {
    // 셀의 개수 반환 함수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categories.count // 카테고리 개수 반환
    }
    
    // 셀을 구성하고 데이터를 전달하는 함수
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.identifier,
                    for: indexPath
                ) as? CategoryCell
        else {
            return UICollectionViewCell()
        }
        
        let isSelected = (indexPath == selectedIndex)
        
        cell.configureUI(title: categories[indexPath.item])
        
        cell.updateAppearance(isSelected: isSelected, backgroundColor: buttonBackgroundColor)
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout

extension CoffeeCategoryCollectionView: UICollectionViewDelegateFlowLayout {
    
    // 셀 크기 설정 함수
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 100, height: 40) // 각 셀의 크기 설정
    }
    
    // 셀이 선택되었을 때 실행하는 함수
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath
        collectionView.reloadData()
        delegate?.categoryButtonDidTap(index: indexPath.row)
    }
}
