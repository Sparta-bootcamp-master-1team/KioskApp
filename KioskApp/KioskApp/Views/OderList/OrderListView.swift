//
//  CartView.swift
//  KioskApp
//
//  Created by 양원식 on 4/8/25.
//
import UIKit
import SnapKit

protocol OrderListViewDataSource: AnyObject {
    var orderList: [OrderItem] { get }
    var labelColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
}

protocol OrderListViewDelegate: AnyObject {
    func orderListViewCancelButtonDidTap()
    func orderListViewOrderButtonDidTap()
}

/// 장바구니 화면을 구성하는 메인 뷰입니다.
/// 타이틀, 주문 리스트, 총 가격, 주문/취소 버튼 등으로 구성되어 있습니다.
class OrderListView: UIView {
    
    weak var dataSource: OrderListViewDataSource?
    weak var delegate: OrderListViewDelegate?
    
    // MARK: - UI Components

    /// "장바구니"라는 타이틀을 표시합니다.
    private let titleLabel = UILabel()
    
    /// 현재 담긴 주문의 총 가격을 표시하는 레이블입니다.
    private let totalPriceLabel = UILabel()
    
    /// 주문 목록(장바구니 항목들)을 표시하는 테이블 뷰입니다.
    let orderListTableView = OrderListTableView()
    
    /// 테이블 뷰의 높이를 동적으로 조정하기 위한 제약 조건입니다.
    private var orderListTableViewHeightConstraint: Constraint?
    
    /// 주문 취소 버튼입니다.
    private let cancelButton = UIButton(type: .system)
    
    /// 주문하기 버튼입니다.
    private let orderButton = UIButton(type: .system)
    
    /// 버튼들을 수평으로 정렬하는 스택 뷰입니다.
    private let buttonStackView = UIStackView()

    // MARK: - Initializers
    
    /// 코드로 뷰를 초기화할 때 호출됩니다.
    override init(frame: CGRect) {
        super.init(frame: frame)
//        orderListTableView.tableView.dataSource = self
//        orderListTableView.delegate = self
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
        setupButtons()
    }

    /// 컴포넌트들의 오토레이아웃 제약 조건을 설정합니다.
    private func setupLayout() {
        // 타이틀
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
        }

        // 주문 목록 테이블
        orderListTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            orderListTableViewHeightConstraint = make.height.greaterThanOrEqualTo(140).constraint
        }

        // 총 가격 레이블
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(orderListTableView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        // 버튼 스택
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16) // 하단 여백
        }
    }

    /// 각 컴포넌트들의 스타일을 지정합니다. (폰트, 색상 등)
    private func setupStyle() {        
        titleLabel.text = "장바구니"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        totalPriceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        totalPriceLabel.textAlignment = .right
    }

    /// 주문취소 및 주문하기 버튼을 구성하고, 스택 뷰로 묶어 추가합니다.
    private func setupButtons() {
        // 주문취소 버튼
        cancelButton.setTitle("주문취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        cancelButton.layer.cornerRadius = 24
        cancelButton.clipsToBounds = true

        // 주문하기 버튼
        orderButton.setTitle("주문하기", for: .normal)
        orderButton.setTitleColor(.white, for: .normal)
        orderButton.backgroundColor = UIColor(red: 62/255, green: 39/255, blue: 35/255, alpha: 1) // 진한 갈색
        orderButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        orderButton.layer.cornerRadius = 24
        orderButton.clipsToBounds = true

        // 스택 뷰에 버튼 추가
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(orderButton)

        // 버튼 스택을 뷰에 추가
        addSubview(buttonStackView)
        
        // 버튼 액션 설정
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }

    
    // MARK: - Action
    
    /// "주문취소" 버튼을 눌렀을 때 실행됩니다.
    /// OrderListManager의 리스트를 초기화하고 UI를 갱신합니다.
    @objc private func didTapCancel() {
        delegate?.orderListViewCancelButtonDidTap()
    }

    
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
    //
    /// 현재 장바구니의 총 가격을 계산해 텍스트로 표시합니다.
    func updateTotalPrice() {
        // 일딴 이렇게 해놨지만 추후 오류 메세지 출력도 좋아보입니다.
        guard let orders = dataSource?.orderList else {
            totalPriceLabel.text = "주문 정보를 불러올 수 없습니다."
            return
        }
        let total = orders.reduce(0) { $0 + $1.price * $1.count }
        totalPriceLabel.text = "총 가격: \(total.formattedWithSeparator)원"
    }
    
    func changeColor() {
        titleLabel.textColor = dataSource?.labelColor
        totalPriceLabel.textColor = dataSource?.labelColor
        orderButton.setTitleColor(dataSource?.buttonTitleColor, for: .normal)
        orderButton.backgroundColor = dataSource?.buttonBackgroundColor
    }
//
//    /// OrderListTableView 내부에서 수량이 변경되었을 때 호출되는 델리게이트 메서드입니다.
//    func orderListTableViewDidUpdate() {
//        updateTotalPrice()
//    }

    // MARK: - Private Methods
}
