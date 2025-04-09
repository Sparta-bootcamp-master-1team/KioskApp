//
//  ProductCell.swift
//  KioskApp
//
//  Created by 박주성 on 4/7/25.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    
    // 셀 재사용 식별자
    static let reuseIdentifier: String = "ProductCell"
    
    // MARK: - 뷰 구성 요소

    // 콘텐츠를 담는 컨테이너 뷰 (둥근 모서리 처리용)
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // 상품 이미지 뷰
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 상품명 레이블
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // 가격 레이블
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 그림자 설정

    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
    }
    
    // 셀 외곽에 그림자 효과
    private func applyShadow() {
        self.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
        self.layer.shadowOpacity = 0.1                 // 그림자 투명도 (연하게)
        self.layer.shadowRadius = 10                   // 그림자 퍼짐 정도
        self.layer.shadowOffset = CGSize(width: 0, height: 6) // 아래 방향으로 그림자
    }
    
    // MARK: - UI 구성

    private func setupUI() {
        self.contentView.addSubview(containerView)
        
        // containerView 내부에 이미지와 텍스트 추가
        [imageView, productNameLabel, priceLabel].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
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
            $0.top.equalTo(productNameLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - UI 데이터 설정

    func configureUI(imageName: String, productName: String, price: Int) {
        imageView.image = UIImage(named: imageName)
        productNameLabel.text = productName
        priceLabel.text = "\(price)"
    }
}
