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

class OrderListTableView: UIView {

    // MARK: - UI Components
    // 뷰에 들어갈 컴포넌트들을 정의하는 공간
    let tableView = UITableView()

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

        // 테이블 뷰에서 스크롤을 비활성화합니다.
        // 셀 개수에 따라 테이블 높이를 늘리고 싶을 때 사용합니다.
        tableView.isScrollEnabled = false
        
        // 테이블 뷰에서 터치를 비활성화 합니다.
        tableView.allowsSelection = false

        // OrderItemCell 클래스를 셀로 등록합니다.
        // 셀 재사용을 위해 identifier를 "OrderItemCell"로 지정합니다.
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")

        // 셀 높이를 자동으로 계산하도록 설정합니다.
        // 셀 안의 콘텐츠 크기에 따라 높이가 유동적으로 결정됩니다.
        tableView.rowHeight = UITableView.automaticDimension

        // 셀의 예상 높이를 지정합니다.
        // 초기 렌더링 성능 향상을 위해 사용되며, 실제 높이는 automaticDimension이 적용됩니다.
        tableView.estimatedRowHeight = 60
        
        
        // iOS 15 버전 이상 부터는 기본적으로 35pt 의 여백이 있어 조정
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 10
        }
        
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
    
    // MARK: - Private Methods
    // 내부 로직 처리용 메서드들
    /// 셀의 위치를 찾아주는 보조 함수
    private func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }

}
