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
    
}
