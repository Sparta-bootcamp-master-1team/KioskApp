//
//  Untitled.swift
//  KioskApp
//
//  Created by 양원식 on 4/8/25.
//

import UIKit
import SnapKit

protocol OrderListTableViewDelegate: AnyObject {
    func orderListTableViewDidUpdate()
}

class OrderListTableView: UIView, UITableViewDelegate, UITableViewDataSource, OrderItemCellDelegate {

    // MARK: - UI Components
    // 뷰에 들어갈 컴포넌트들을 정의하는 공간
    private let tableView = UITableView()

    weak var delegate: OrderListTableViewDelegate?

    // MARK: - Initializers
    // init(frame:) 또는 required init?(coder:) 구현
    /// 코드로 초기화할 때 호출되는 생성자입니다.
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSubviews()
        setupLayout()
        setupStyle()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    // 뷰 설정 관련 함수들 (뷰 계층 설정, 스타일 설정 등)

    /// 뷰 계층 구성 (addSubview)
    private func setupSubviews() {
        addSubview(tableView)
    }

    /// 오토레이아웃 설정 (SnapKit 등)
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 스타일 설정 (색상, 폰트, 코너 등)
    private func setupStyle() {
        // 테이블 뷰 모양 설정
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
    }

    /// 테이블 뷰의 delegate, dataSource 설정과 셀 등록, 스크롤 여부 등을 설정합니다.
    private func setupTableView() {
        // 테이블 뷰의 delegate를 현재 클래스(self)로 설정합니다.
        // 셀 선택 등 사용자 상호작용을 제어할 수 있습니다.
        tableView.delegate = self

        // 테이블 뷰의 데이터 소스를 현재 클래스(self)로 설정합니다.
        // 셀 개수 및 셀 생성 등 데이터를 테이블에 제공하는 역할을 합니다.
        tableView.dataSource = self

        // 테이블 뷰에서 스크롤을 비활성화합니다.
        // 셀 개수에 따라 테이블 높이를 늘리고 싶을 때 사용합니다.
        tableView.isScrollEnabled = false

        // OrderItemCell 클래스를 셀로 등록합니다.
        // 셀 재사용을 위해 identifier를 "OrderItemCell"로 지정합니다.
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")

        // 셀 높이를 자동으로 계산하도록 설정합니다.
        // 셀 안의 콘텐츠 크기에 따라 높이가 유동적으로 결정됩니다.
        tableView.rowHeight = UITableView.automaticDimension

        // 셀의 예상 높이를 지정합니다.
        // 초기 렌더링 성능 향상을 위해 사용되며, 실제 높이는 automaticDimension이 적용됩니다.
        tableView.estimatedRowHeight = 60
    }

    // MARK: - Action
    // 버튼 등 액션 연결 및 함수

    // MARK: - Public Methods
    // 외부에서 이 뷰에 접근하는 API 제공 (ex: updateLabel(with:))

    /// 테이블 뷰를 다시 로드합니다.
    func reloadData() {
        tableView.reloadData()
    }

    /// 테이블 뷰의 contentSize.height를 반환합니다. 외부에서 높이 계산에 사용됩니다.
    func intrinsicContentHeight() -> CGFloat {
        return tableView.contentSize.height
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 28)

        // 메인 스택 뷰
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fill

        // 왼쪽 스택 (메뉴)
        let leftStack = UIStackView()
        leftStack.axis = .horizontal
        leftStack.alignment = .leading
        let menuLabel = UILabel()
        menuLabel.text = "메뉴"
        menuLabel.font = .boldSystemFont(ofSize: 14)
        menuLabel.textAlignment = .left
        leftStack.addArrangedSubview(menuLabel)

        // 가운데 스택 (수량)
        let centerStack = UIStackView()
        centerStack.axis = .horizontal
        centerStack.alignment = .center
        centerStack.spacing = 4
        let quantityLabel = UILabel()
        quantityLabel.text = "수량"
        quantityLabel.font = .boldSystemFont(ofSize: 14)
        quantityLabel.textAlignment = .center
        centerStack.addArrangedSubview(quantityLabel)

        // 오른쪽 스택 (가격)
        let rightStack = UIStackView()
        rightStack.axis = .horizontal
        rightStack.alignment = .leading
        rightStack.spacing = 4
        let priceLabel = UILabel()
        priceLabel.text = "가격"
        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textAlignment = .right
        rightStack.addArrangedSubview(priceLabel)

        // 스택들을 메인 스택에 추가
        hStackView.addArrangedSubview(leftStack)
        hStackView.addArrangedSubview(centerStack)
        hStackView.addArrangedSubview(rightStack)

        // 메인 스택을 헤더 뷰에 추가
        headerView.addSubview(hStackView)

        // 메인 스택 레이아웃 설정
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16))
        }

        // 각 스택 비율 설정 (메뉴: 60%, 수량: 20%, 가격: 20%)
        leftStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.55)
        }

        centerStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.25)
        }

        rightStack.snp.makeConstraints { make in
            make.width.equalTo(hStackView).multipliedBy(0.2)
        }

        return headerView
    }

    // 섹션 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }

    /// 섹션 개수를 명시적으로 설정해야 헤더가 보입니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// 테이블 뷰의 셀 개수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderListManager.shared.items.count
    }

    /// 각 셀에 맞는 데이터를 설정하고 반환합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 꺼내고, OrderItemCell로 캐스팅합니다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell else {
            // 캐스팅에 실패할 경우 기본 셀을 반환하여 앱 크래시 방지
            return UITableViewCell()
        }
        // 현재 indexPath에 해당하는 주문 데이터를 가져옵니다.
        let order = OrderListManager.shared.items[indexPath.row]

        // 셀에 주문 데이터를 설정합니다 (ex: 이름, 수량, 가격 등)
        cell.configure(with: order)

        // 델리게이트 연결
        cell.delegate = self

        // 설정된 셀을 반환하여 테이블 뷰에 표시합니다.
        return cell
    }

    // MARK: - CartItemCellDelegate

    func orderItemCellDidTapIncrement(_ cell: OrderItemCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        let item = OrderListManager.shared.items[indexPath.row].coffee
        OrderListManager.shared.add(item)
        reloadData()
        delegate?.orderListTableViewDidUpdate()
    }

    func orderItemCellDidTapDecrement(_ cell: OrderItemCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        let item = OrderListManager.shared.items[indexPath.row].coffee
        OrderListManager.shared.decrement(item)
        reloadData()
        delegate?.orderListTableViewDidUpdate()
    }

    func orderItemCellDidTapRemove(_ cell: OrderItemCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        let item = OrderListManager.shared.items[indexPath.row].coffee
        OrderListManager.shared.remove(item)
        reloadData()
        delegate?.orderListTableViewDidUpdate()
    }

    // MARK: - Private Methods
    // 내부 로직 처리용 메서드들
    /// 셀의 위치를 찾아주는 보조 함수
    private func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }

}
