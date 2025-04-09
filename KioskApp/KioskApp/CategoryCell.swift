//
//  CategoryCell.swift
//  KioskApp
//
//  Created by 조선우 on 4/8/25.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    // CollectionView에서 재사용하기 위한 셀의 식별자
    static let identifier = "CategoryCell"
    
    // MARK: UILabel
    
    // 셀의 titleLabel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
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
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true
    }
    
    //MARK: configureUI
    
    // 데이터 전달
    func configureUI(title: String) {
        titleLabel.text = title
    }
    
    //MARK: isSelected
    
    // 셀이 선택되었을 때 상태 처리
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = #colorLiteral(red: 0.2353164852, green: 0.1198656633, blue: 0.06329972297, alpha: 1)
                titleLabel.textColor = .white
            } else {
                contentView.backgroundColor = .white
                titleLabel.textColor = .black
            }
        }
    }
}
