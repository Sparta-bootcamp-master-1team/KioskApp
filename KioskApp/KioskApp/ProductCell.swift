//
//  ProductCell.swift
//  KioskApp
//
//  Created by 박주성 on 4/7/25.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ProductCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView, productNameLabel, priceLabel].forEach { self.contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureUI(imageName: String, productName: String, price: String) {
        imageView.image = UIImage(named: imageName)
        productNameLabel.text = productName
        priceLabel.text = price
    }
}
