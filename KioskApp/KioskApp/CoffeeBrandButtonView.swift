//
//  HeaderButtonVeiw.swift
//  KioskApp
//
//  Created by 조선우 on 4/8/25.
//

import UIKit
import SnapKit

class CoffeeBrandButtonView: UIView {
    // 커피 브랜드 로고 버튼
    private let coffeeBrandButton: UIButton = {
        let button = UIButton()
        let targetSize = CGSize(width: 200, height: 100)
        let resizedImage = UIImage(named: "megaLogo")?.resize(targetSize: targetSize)
        
        button.setImage(resizedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.showsMenuAsPrimaryAction = true // 버튼 누르면 Menu 바로 표시
        return button
    }()
    
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
            $0.edges.equalToSuperview()
        }
    }
    
    // "메가커피", "빽다방", "더벤티" 선택하는 UIMenu
    private func coffeeBrandMenu() {
        let coffeeBrandItems = [
            UIAction(title: "메가커피", handler: { _ in print("메가커피")}),
            UIAction(title: "빽다방", handler: { _ in print("빽다방")}),
            UIAction(title: "더벤티", handler: { _ in print("더벤티")})
        ]
        
        let menu = UIMenu(title: "커피 브랜드를 선택해주세요.", children: coffeeBrandItems)
        // coffeeBrandButton에 메뉴 연결
        coffeeBrandButton.menu = menu
    }
}
