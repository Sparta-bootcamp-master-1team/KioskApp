//
//  ViewModel.swift
//  KioskApp
//
//  Created by 양원식 on 4/9/25.
//
import Foundation

final class OrderViewModel {
    
    // MARK: - 상태
    
    private(set) var selectedCategory: Category = .coffee {
        didSet {
            categoryChanged?(selectedCategory)
        }
    }
    
    private(set) var selectedBrand: Brand = .baik {
        didSet {
            brandChanged?(selectedBrand)
        }
    }
    
    private(set) var orderList: [OrderItem] = [] {
        didSet {
            orderProductsChanged?(orderList)
        }
    }
    
    // MARK: - 클로저
    ///
    var orderProductsChanged: (([OrderItem]) -> Void)?
    var categoryChanged: ((Category) -> Void)?
    var brandChanged: ((Brand) -> Void)?
    
    // MARK: - 주문 관리 메소드
    
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
    
    
    
}
