//
//  ViewModel.swift
//  KioskApp
//
//  Created by 양원식 on 4/9/25.
//
import Foundation

/// 주문 화면의 상태와 로직을 관리하는 ViewModel
final class OrderViewModel {
    
    // MARK: - 상태
    
    /// 현재 선택된 카테고리 (기본값: .coffee)
    private(set) var selectedCategory: Category = .coffee {
        didSet {
            categoryChanged?(selectedCategory)
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
    var categoryChanged: ((Category) -> Void)?
    
    /// 브랜드가 변경될 때 호출되는 클로저
    var brandChanged: ((Brand) -> Void)?
    
    /// 옵션이 변경될 때 호출되는 클로저
    var OptionChanged: ((Option) -> Void)?
    
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
    ///
    /// - Parameter brand: 변경할 브랜드
    func changeBrand(_ brand: Brand) {
        selectedBrand = brand
    }
}
