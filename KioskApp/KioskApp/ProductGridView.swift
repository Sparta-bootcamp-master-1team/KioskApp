//
//  ProductGridViewg.swift
//  KioskApp
//
//  Created by 박주성 on 4/7/25.
//

import UIKit
import SnapKit

class ProductGridView: UIView {
    
    // 상품 목록을 표시할 컬렉션 뷰
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.alwaysBounceVertical = false // 수직 바운스 비활성화
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        return collectionView
    }()
    
    // 페이지 인디케이터 (하단 점)
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black // 현재 페이지 색상
        pageControl.pageIndicatorTintColor = .systemGray    // 나머지 점 색상
        return pageControl
    }()
    
    // MARK: - DiffableDatasource 정의
    
    enum Section { case main }
    typealias Item = Beverage
    private(set) var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - 초기화
    
    init() {
        super.init(frame: .zero)
        setupUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 구성
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        [collectionView, pageControl].forEach { self.addSubview($0) }
        
        // 컬렉션 뷰 오토레이아웃
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 페이지 컨트롤 오토레이아웃
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    // MARK: - 컬렉션 뷰 구성
    
    private func configureCollectionView() {
        // DiffableDatasource 구성
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            // 셀 생성 및 구성
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.reuseIdentifier,
                for: indexPath
            ) as! ProductCell
            
            cell.configureUI(imageName: item.imageName, productName: item.name, price: item.price)
            return cell
        })
    }
    
    // MARK: - 컬렉션 뷰 레이아웃
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        // 아이템 사이즈: 셀 하나의 사이즈 (2개씩 나열)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 가로 그룹: 한 행에 두 개의 셀
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [item, item]
        )
        
        // 세로 그룹: 두 줄 묶음 (2 x 2 구조)
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [horizontalGroup, horizontalGroup]
        )
        
        // 섹션 구성
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered // 가로 페이징
        
        // 페이지 컨트롤 업데이트 핸들러
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded())
            self.pageControl.currentPage = index
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Snapshot 구성
    
    private func configureSnapshot(items: [Beverage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])       // 섹션 추가
        snapshot.appendItems(items, toSection: .main) // 아이템 추가
        self.datasource.apply(snapshot)        // 데이터 적용
    }
    
    // MARK: - 페이지 컨트롤 구성
    
    private func configurePageControl(count: Int) {
        let pageCount = Int(ceil(Double(count) / 4.0)) // 한 페이지에 4개(2x2)씩
        pageControl.numberOfPages = pageCount
    }
    
    // MARK: - 외부 구성 메서드
    
    // 외부에서 모델 배열을 넘겨받아 셀과 페이지 컨트롤 구성
    func configure(items: [Beverage]) {
        configureSnapshot(items: items)
        configurePageControl(count: items.count)
    }
}
