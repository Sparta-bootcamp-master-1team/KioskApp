//
//  ProductListView.swift
//  KioskApp
//
//  Created by 박주성 on 4/7/25.
//

import UIKit
import SnapKit

class ProductListView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        collectionView.alwaysBounceVertical = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        return collectionView
    }()
    enum Section { case main }
    typealias Item = TestModel
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    init() {
        super.init(frame: .zero)
        setupUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.reuseIdentifier,
                for: indexPath
            ) as! ProductCell
            
            cell.configureUI(imageName: item.imageName, productName: item.name, price: item.price)
            
            return cell
        })
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [item, item]
        )
        
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [horizontalGroup, horizontalGroup]
        )
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureSnapshot(items: [TestModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        self.datasource.apply(snapshot)
    }

}
