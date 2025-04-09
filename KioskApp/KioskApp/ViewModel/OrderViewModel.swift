//
//  ViewModel.swift
//  KioskApp
//
//  Created by 양원식 on 4/9/25.
//
import Foundation

final class OrderViewModel {
    
    // MARK: - 클로저
    ///
    var orderProductsChanged: (([OrderItem]) -> Void)?
    var categoryChanged: ((Category) -> Void)?
    var brandChanged: ((Brand) -> Void)?
    
}
