//
//  CartView.swift
//  KioskApp
//
//  Created by 양원식 on 4/8/25.
//
import UIKit
import SnapKit

/// 장바구니 화면을 구성하는 메인 뷰입니다.
/// 타이틀, 주문 리스트, 총 가격, 주문/취소 버튼 등으로 구성되어 있습니다.
class OrderListView: UIView, OrderListTableViewDelegate {
    
    // MARK: - UI Components
    /// "장바구니"라는 타이틀을 표시합니다.
    private let titleLabel = UILabel()
    // MARK: - Initializers
    
    /// 코드로 뷰를 초기화할 때 호출됩니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Setup Methods

    /// UI 컴포넌트들을 뷰에 추가합니다.
    private func setupSubViews() {
        addSubview(titleLabel)
    }
    /// 컴포넌트들의 오토레이아웃 제약 조건을 설정합니다.
    private func setupLayout() {
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
        }
    }

    /// 각 컴포넌트들의 스타일을 지정합니다. (폰트, 색상 등)
    private func setupStyle() {
        self.backgroundColor = .white
        
        titleLabel.text = "장바구니"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
    }

    // MARK: - Action
    
    
    // MARK: - Public Methods

    // MARK: - Private Methods
}
