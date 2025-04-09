//
//  CategoryCollectionView.swift
//  KioskApp
//
//  Created by 조선우 on 4/8/25.
//

import UIKit
import SnapKit

class CoffeeCategoryCollectionView: UIView,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout {
    // 메뉴 카테고리 배열
    private let categories = ["추천메뉴", "커피(ICED)", "커피(HOT)", "음료(ICED)", "음료(HOT)", "디저트"]
    
    // MARK: UICollectionView
    
    // 메뉴 카테고리를 위한 UICollectionView 생성
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return view
    }()
    
    // MARK: init 및 UI 설정
    
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
    
    //MARK: layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 초기 선택 상태 설정
        let indexPath = IndexPath(item: 0, section: 0) // 첫 번째 셀
        categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        // 선택된 셀의 반환 및 스타일 적용
        if let cell = categoryCollectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.isSelected = true
        }
    }
    
    // MARK: UICollectionView DataSource & Delegate Methods
    
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
        
        cell.configureUI(title: categories[indexPath.item]) // 셀에 데이터 전달
        return cell
    }
    
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
        print("\(categories[indexPath.item]) 선택됨") // 실행되는지 테스트
    }
}
