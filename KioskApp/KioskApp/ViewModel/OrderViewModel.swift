//
//  ViewModel.swift
//  KioskApp
//
//  Created by 양원식 on 4/9/25.
//
import Foundation

/// 주문 화면의 상태와 로직을 관리하는 ViewModel
final class OrderViewModel {
    
    var beverage: [Beverage]?

    var filteredBeverage: [Beverage] = []
    // MARK: - 상태
    
    /// 현재 선택된 브랜드 (기본값: .mega)
    private(set) var selectedBrand: Brand = .mega {
        didSet {
            brandChanged?(selectedBrand)
        }
    }
    
    /// 현재 선택된 카테고리 (기본값: .coffeeHot)
    private(set) var selectedCategory: Category = .coffeeHot {
        didSet {
            guard let beverage else { return }
            filteredBeverage = beverage.filter{
                ($0.category == selectedCategory)
                && ($0.brand == selectedBrand)
            }
            categoryChanged?(filteredBeverage)
        }
    }
    
    /// 현재 주문한 상품 리스트
    private(set) var orderList: [OrderItem] = [] {
        didSet {
            orderProductsChanged?(orderList)
        }
    }
    
    // MARK: - 클로저
    
    /// 브랜드가 변경될 때 호출되는 클로저
    var brandChanged: ((Brand) -> Void)?

    /// 카테고리가 변경될 때 호출되는 클로저
    var categoryChanged: (([Beverage]) -> Void)?
    
    /// 주문 목록이 변경될 때 호출되는 클로저
    var orderProductsChanged: (([OrderItem]) -> Void)?
    
    var dataFetchStarted: (() -> Void)?
    var dataFetchCompleted: (() -> Void)?
    var dataFetchFailed: (() -> Void)?

    func selectedRecommend() {
        guard let beverage else { return }
        filteredBeverage = beverage.filter{ ($0.recommended != nil) && ($0.brand == selectedBrand) }
        categoryChanged?(filteredBeverage)
    }
    
    func fetchProducts() {
        let dataProvider = DataProvider()
        Task {
            await MainActor.run {
                dataFetchStarted?()
            }
            do {
                let beverages = try await dataProvider.process()
                await MainActor.run {
                    self.beverage = beverages
                    self.selectedRecommend()
                    dataFetchCompleted?()
                }
            } catch {
                dataFetchFailed?()
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - 주문 관리 메소드
    
    /// 음료를 주문 목록에 추가합니다.
    /// 동일한 음료가 이미 존재하면 수량을 1 증가시킵니다.
    ///
    /// - Parameter beverage: 추가할 음료
    func addOrder(_ beverage: Beverage) {
        if let index = orderList.firstIndex(where: { $0.name == beverage.name && $0.brand == beverage.brand && $0.category == beverage.category }) {
            guard orderList[index].count < 10 else { return }
            orderList[index].increaseCount()
        } else {
            let newItem = OrderItem(name: beverage.name,
                                    price: beverage.price,
                                    brand: beverage.brand,
                                    category: beverage.category,
                                    count: 1)
            orderList.insert(newItem, at: 0)
        }
    }
    
    /// 주문 항목의 수량을 1 증가시킵니다.
    ///
    /// - Parameter beverage: 수량을 증가시킬 음료
    func orderCountIncreament(_ beverage: OrderItem) {
        guard let index = orderList.firstIndex(where: { $0 == beverage }) else { return }
        guard orderList[index].count < 10 else { return }
        orderList[index].increaseCount()
        orderProductsChanged?(orderList)
    }
    
    /// 주문 항목의 수량을 1 감소시킵니다.
    /// 수량이 1일 경우 해당 항목을 삭제합니다.
    ///
    /// - Parameter beverage: 수량을 감소시킬 음료
    func orderCountDecreament(_ beverage: OrderItem) {
        guard let index = orderList.firstIndex(where: { $0 == beverage }) else { return }
        if orderList[index].count > 1 {
            orderList[index].decreaseCount()
            orderProductsChanged?(orderList)
        }
    }
    
    /// 주문 항목을 삭제합니다.
    ///
    /// - Parameter beverage: 삭제할 음료
    func removeOrder(_ beverage: OrderItem) {
        guard let index = orderList.firstIndex(where: { $0 == beverage }) else { return }
        orderList.remove(at: index)
    }
    
    func orderCacelAll() {
        orderList.removeAll()
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
        selectedRecommend()
    }
    
    
}
