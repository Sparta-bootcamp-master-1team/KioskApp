//
//  HeaderButtonVeiw.swift
//  KioskApp
//
//  Created by 조선우 on 4/8/25.
//

import UIKit
import SnapKit

protocol CoffeeButtonViewDelegate: AnyObject {
    func brandButtonDidTap(brand: Brand)
}

class CoffeeBrandButtonView: UIView {
    
    weak var delegate: CoffeeButtonViewDelegate?
    
    // MARK: - coffeeBrandButton 설정
    
    // 커피 브랜드 로고 버튼
    private let coffeeBrandButton: UIButton = {
        let originalImage = UIImage(named: "MegaLogo")
        let resizedImage = originalImage?.resized(to: CGSize(width: 180, height: 60))
        
        // UIButton Configuration 사용
        var configuration = UIButton.Configuration.plain()
        configuration.image = resizedImage
        configuration.title = "▼"
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.baseForegroundColor = .black
        // 텍스트의 폰트를 커스터마이징 함
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 20)
            return outgoing
        }
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.showsMenuAsPrimaryAction = true // 버튼 누르면 Menu 바로 표시
        return button
    }()
    
    // MARK: - init 및 UI 설정

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        coffeeBrandMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(coffeeBrandButton)
        
        coffeeBrandButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
    
    // MARK: - 커피 브랜드 변경 처리
    
    private func coffeeBrandChanged(brandName: String) {
        guard let brand = Brand(rawValue: brandName) else { return }
        delegate?.brandButtonDidTap(brand: brand)
    }
    
    func coffeeBrandImageChange(imageName: String) {
        let image = UIImage(named: imageName)
        let resizedImage = image?.resized(to: CGSize(width: 180, height: 60))

        var config = coffeeBrandButton.configuration
        config?.image = resizedImage
        coffeeBrandButton.configuration = config
    }
}

// MARK: - UIMenu 설정

extension CoffeeBrandButtonView {
    // "메가커피", "빽다방", "더벤티" 선택하는 UIMenu
    private func coffeeBrandMenu() {
        let coffeeBrandItems = [
            UIAction(title: "메가커피", handler: { _ in self.coffeeBrandChanged(brandName: "Mega")}),
            UIAction(title: "빽다방", handler: { _ in self.coffeeBrandChanged(brandName: "Paik")}),
            UIAction(title: "더벤티", handler: { _ in self.coffeeBrandChanged(brandName: "TheVenti")})
        ]
        
        let menu = UIMenu(title: "커피 브랜드를 선택해주세요.", children: coffeeBrandItems)
        // coffeeBrandButton에 메뉴 연결
        coffeeBrandButton.menu = menu
    }
}

// MARK: - 이미지 사이즈 조정을 위한 UIImage 확장

extension UIImage {
    // 이미지 크기를 조정하여 반환하는 함수
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize) // 이미지 크기를 재단함
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize)) // 이미지를 영역에 맞게 다시 그림
        }
    }
}
