//
//  OrderItemCell.swift
//  KioskApp
//
//  Created by 양원식 on 4/8/25.
//

import UIKit
import SnapKit

/// 장바구니 항목 셀에서 발생하는 사용자 액션을 전달하기 위한 델리게이트 프로토콜입니다.
protocol OrderItemCellDelegate: AnyObject {
    func orderItemCellDidTapIncrement(_ cell: OrderItemCell)
    func orderItemCellDidTapDecrement(_ cell: OrderItemCell)
    func orderItemCellDidTapRemove(_ cell: OrderItemCell)
}

class OrderItemCell: UITableViewCell {
    // MARK: - UI Components
    // 뷰에 들어갈 컴포넌트들을 정의하는 공간
    /// 셀 전체를 감싸는 수평 스택 뷰입니다.
    private let hStackView = UIStackView()
    /// 왼쪽 스택: 메뉴 이름
    private let leftStack = UIStackView()
    /// 가운데 스택: 수량 조절 버튼 + 수량
    private let centerStack = UIStackView()
    /// 오른쪽 스택: 가격 + 삭제 버튼
    private let rightStack = UIStackView()
    
    /// 메뉴 이름을 표시하는 라벨입니다.
    private let titleLabel = UILabel()
    /// 수량을 표시하는 라벨입니다.
    private let quantityLabel = UILabel()
    /// 가격을 표시하는 라벨입니다.
    private let priceLabel = UILabel()
    
    /// 수량 감소 버튼입니다.
    private let minusButton = UIButton(type: .system)
    /// 수량 증가 버튼입니다.
    private let plusButton = UIButton(type: .system)
    /// 항목 삭제 버튼입니다.
    private let removeButton = UIButton(type: .system)
    
    /// 셀에서 발생하는 액션을 전달할 델리게이트입니다.
    weak var delegate: OrderItemCellDelegate?
    
    // MARK: - Initializers
    // init(frame:) 또는 required init?(coder:) 구현
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupLayout()
        setupStyle()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    // 뷰 설정 관련 함수들 (뷰 계층 설정, 스타일 설정 등)
    
    private func setupSubviews() {
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fill
        // 왼쪽: 메뉴 텍스트
        leftStack.axis = .horizontal
        leftStack.addArrangedSubview(titleLabel)
        
        // 가운데: 수량 조절 버튼
        centerStack.axis = .horizontal
        centerStack.spacing = 4
        centerStack.addArrangedSubview(minusButton)
        centerStack.addArrangedSubview(quantityLabel)
        centerStack.addArrangedSubview(plusButton)
        
        // 오른쪽: 가격 + 삭제
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.addArrangedSubview(priceLabel)
        
        //rightStack.addArrangedSubview(removeButton)

        // 메인 스택에 모두 추가
        hStackView.addArrangedSubview(leftStack)
        hStackView.addArrangedSubview(centerStack)
        hStackView.addArrangedSubview(rightStack)

        contentView.addSubview(hStackView)
    }
    
    /// 오토레이아웃 설정 (SnapKit 등)
    private func setupLayout() {
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        removeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        leftStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.55)
        }
        centerStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.25)
        }
        rightStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.2)
        }
    }
    
    /// 스타일 설정 (색상, 폰트, 코너 등)
    private func setupStyle() {
        // 메뉴 제목
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.lineBreakMode = .byTruncatingTail // 긴 텍스트는 ... 처리
        titleLabel.numberOfLines = 0
        
        // 다른 뷰들이 가로 공간을 더 많이 차지해야 할 경우,
        // titleLabel은 자신의 콘텐츠보다 넓게 늘어나지 않도록 우선순위를 낮춥니다.
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // 가로 공간이 부족할 경우, titleLabel은 잘려도 괜찮다고 우선순위를 낮춥니다.
        // 즉, 긴 텍스트가 ...으로 처리될 수 있게 유연하게 설정합니다.
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        
        // 수량 텍스트
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textAlignment = .center
        
        // 가격 텍스트
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textAlignment = .right
        
        // 버튼 아이콘 설정 및 색상 지정
        let minusImage = UIImage(systemName: "minus.circle")
        minusButton.setImage(minusImage, for: .normal)
        minusButton.tintColor = .gray
        
        let plusImage = UIImage(systemName: "plus.circle")
        plusButton.setImage(plusImage, for: .normal)
        plusButton.tintColor = .gray
        
        
        // 의논 필요
        let trashImage = UIImage(systemName: "trash")
        removeButton.setImage(trashImage, for: .normal)
        removeButton.tintColor = .gray
    }
    
    /// 버튼 클릭 시 실행될 메서드를 연결합니다.
    private func setupActions() {
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
    }
    
    // MARK: - Action
    // 버튼 등 액션 연결 및 함수
    /// 수량 감소 버튼 클릭 시 델리게이트에 전달
    @objc private func didTapMinus() {
        delegate?.orderItemCellDidTapDecrement(self)
    }
    
    /// 수량 증가 버튼 클릭 시 델리게이트에 전달
    @objc private func didTapPlus() {
        delegate?.orderItemCellDidTapIncrement(self)
    }
    
    /// 삭제 버튼 클릭 시 델리게이트에 전달
    @objc private func didTapRemove() {
        delegate?.orderItemCellDidTapRemove(self)
    }

    
    // MARK: - Public Methods
    /// 주문 항목(OrderItem)을 받아 UI 요소에 값을 설정합니다.
    func configure(with order: OrderItem) {
        titleLabel.text = "(\(order.coffee.brand)) \(order.coffee.name)"
        quantityLabel.text = "\(order.quantity)"
        priceLabel.text = "\(order.coffee.price * order.quantity)원"
    }

    
    // MARK: - Private Methods
    // 내부 로직 처리용 메서드들
}
