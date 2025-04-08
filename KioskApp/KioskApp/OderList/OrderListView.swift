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
    
    /// 현재 담긴 주문의 총 가격을 표시하는 레이블입니다.
    private let totalPriceLabel = UILabel()
    
    /// 주문 목록(장바구니 항목들)을 표시하는 테이블 뷰입니다.
    private let orderListTableView = OrderListTableView()
    
    /// 테이블 뷰의 높이를 동적으로 조정하기 위한 제약 조건입니다.
    private var orderListTableViewHeightConstraint: Constraint?
    
    // MARK: - Initializers
    
    /// 코드로 뷰를 초기화할 때 호출됩니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        orderListTableView.delegate = self
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
        addSubview(orderListTableView)
        addSubview(totalPriceLabel)
    }

    /// 컴포넌트들의 오토레이아웃 제약 조건을 설정합니다.
    private func setupLayout() {
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
        }

        // 주문 목록 테이블
        orderListTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            orderListTableViewHeightConstraint = make.height.greaterThanOrEqualTo(140).constraint
        }

        // 총 가격 레이블
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(orderListTableView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

    }

    /// 각 컴포넌트들의 스타일을 지정합니다. (폰트, 색상 등)
    private func setupStyle() {
        self.backgroundColor = .white
        
        titleLabel.text = "장바구니"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        totalPriceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        totalPriceLabel.textAlignment = .right
    }

    }

    // MARK: - Action
    
    
    // MARK: - Public Methods

    /// 테이블을 다시 그리며, 내부 높이도 계산하여 업데이트합니다.
    func reloadTable() {
        orderListTableView.reloadData()
        
        DispatchQueue.main.async {
            self.orderListTableView.layoutIfNeeded()
            let height = self.orderListTableView.intrinsicContentHeight()
            self.orderListTableViewHeightConstraint?.update(offset: max(140, height))
            self.updateTotalPrice()
        }
    }

    /// 현재 장바구니의 총 가격을 계산해 텍스트로 표시합니다.
    func updateTotalPrice() {
        let total = OrderListManager.shared.totalPrice()
        totalPriceLabel.text = "총 가격: \(total)원"
    }

    /// OrderListTableView 내부에서 수량이 변경되었을 때 호출되는 델리게이트 메서드입니다.
    func orderListTableViewDidUpdate() {
        updateTotalPrice()
    }

    // MARK: - Private Methods
}
