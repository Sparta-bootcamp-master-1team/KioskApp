//
//  ViewModel.swift
//  KioskApp
//
//  Created by 양원식 on 4/9/25.
//
import Foundation

/// 주문 화면의 상태와 로직을 관리하는 ViewModel
final class OrderViewModel {
    
    // MARK: - 데이터 저장
    /// JSON으로부터 불러온 전체 상품 데이터를 저장하는 프로퍼티입니다.
    /// 내부적으로 `fetchProductData()`를 통해 주입되며,
    /// `selectedBrand`, `selectedCategory`, `selectedOption` 조합에 따라 필터링된 음료 리스트를 제공합니다.
    private var product: Product?
    
    /// 현재 선택된 브랜드, 카테고리, 옵션에 따라 필터링된 음료 목록을 반환합니다.
    /// - Returns: 선택된 조건에 맞는 `[Beverage]` 배열 (데이터가 없으면 `nil`)
    var beverage: [Beverage]? {
        product?.fetchData(brand: selectedBrand, category: selectedCategory, option: selectedOption)
    }
    
    // MARK: - 상태
    
    /// 현재 선택된 카테고리 (기본값: .coffee)
    private(set) var selectedCategory: Category = .coffee {
        didSet {
            categoryChanged?()
        }
    }
    
    /// 현재 선택된 브랜드 (기본값: .mega)
    private(set) var selectedBrand: Brand = .mega {
        didSet {
            brandChanged?(selectedBrand)
        }
    }
    
    /// 현재 주문한 상품 리스트
    private(set) var orderList: [OrderItem] = [] {
        didSet {
            orderProductsChanged?(orderList)
        }
    }
    
    /// 현재 선택된 옵션 (기본값: .hot)
    private(set) var selectedOption: Option = .hot {
        didSet {
            OptionChanged?(selectedOption)
        }
    }
    
    // MARK: - 클로저
    
    /// 주문 목록이 변경될 때 호출되는 클로저
    var orderProductsChanged: (([OrderItem]) -> Void)?
    
    /// 카테고리가 변경될 때 호출되는 클로저
    var categoryChanged: (() -> Void)?
    
    /// 브랜드가 변경될 때 호출되는 클로저
    var brandChanged: ((Brand) -> Void)?
    
    /// 옵션이 변경될 때 호출되는 클로저
    var OptionChanged: ((Option) -> Void)?
    
    /// JSON 파일에서 상품 데이터를 불러와 ViewModel에 저장합니다.
    /// 데이터가 성공적으로 로드되면 `product` 프로퍼티에 저장되고,
    /// 선택된 조건에 따라 필터링된 상품 목록을 사용할 수 있게 됩니다.
    ///
    /// - Parameter completion: 로딩 결과를 알리는 완료 핸들러 (성공: `.success`, 실패: `.failure`)
    func fetchProductData(completion: ((Result<Void, Error>) -> Void)? = nil) {
        let service = DataService()
        service.fetchData { [weak self] result in
            switch result {
            case .success(let product):
                self?.product = product
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - 주문 관리 메소드
    
    /// 음료를 주문 목록에 추가합니다.
    /// 동일한 음료가 이미 존재하면 수량을 1 증가시킵니다.
    ///
    /// - Parameter beverage: 추가할 음료
    func addOrder(_ beverage: Beverage) {
        if let index = orderList.firstIndex(where: { $0.name == beverage.name && $0.brand == beverage.brand }) {
            orderList[index].increaseCount()
        } else {
            let newItem = OrderItem(name: beverage.name,
                                    price: beverage.price,
                                    brand: beverage.brand,
                                    count: 1)
            orderList.append(newItem)
        }
    }
    
    /// 주문 항목의 수량을 1 증가시킵니다.
    ///
    /// - Parameter beverage: 수량을 증가시킬 음료
    func orderCountIncreament(_ beverage: Beverage) {
        guard let index = orderList.firstIndex(where: { $0.name == beverage.name && $0.brand == beverage.brand }) else { return }
        orderList[index].increaseCount()
    }
    
    /// 주문 항목의 수량을 1 감소시킵니다.
    /// 수량이 1일 경우 해당 항목을 삭제합니다.
    ///
    /// - Parameter beverage: 수량을 감소시킬 음료
    func orderCountDecreament(_ beverage: Beverage) {
        guard let index = orderList.firstIndex(where: { $0.name == beverage.name && $0.brand == beverage.brand }) else { return }
        if orderList[index].count > 1 {
            orderList[index].decreaseCount()
        } else {
            orderList.remove(at: index)
        }
    }
    
    // MARK: - 필터 변경
    
    /// 현재 선택된 카테고리를 변경합니다.
    ///
    /// - Parameter category: 변경할 카테고리
    func changeCategory(_ category: Category) {
        selectedCategory = category
    }
    
    /// 현재 선택된 브랜드를 변경합니다.
    /// - Parameter brand: 변경할 브랜드
    func changeBrand(_ brand: Brand) {
        
        selectedBrand = brand
        selectedCategory = .coffee
        selectedOption = .hot
        
        /// 회의 필요
        // categoryChanged?(beverage ?? [])
    }
    
    
}
