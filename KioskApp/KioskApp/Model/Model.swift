import Foundation

/// 카테고리 (Coffee, Beverage, Desert)
enum Category: String, Decodable {
    case coffeeHot = "CoffeeHOT"
    case coffeeIce = "CoffeeICE"
    case beverageHot = "BeverageHOT"
    case beverageIce = "BeverageICE"
    case dessert = "Dessert"
}

/// 3사 브랜드 (Baik, TheVenti, Mega)
enum Brand: String, Decodable {
    case paik = "Paik"
    case theVenti = "TheVenti"
    case mega = "Mega"
}

/// 제품 하나의 세부정보 리스트
struct Beverage: Decodable, Hashable {
    let name: String
    let price: Int
    let category: Category
    let brand: Brand
    var recommended: Bool?
    var imageName: String?
}



/// 장바구니 제품 모델
struct OrderItem {
    let name: String
    let price: Int
    let brand: Brand
    var count: Int
    
    var orderTitle: String {
        return "(\(brand.rawValue)) \(name)"
    }
    
    mutating func increaseCount() {
        self.count += 1
    }
    
    mutating func decreaseCount() {
        self.count -= 1
    }
    
}

struct NetworkResponse: Decodable {
    let name: String
    let downloadURL: String?
    let path: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case downloadURL = "download_url"
        case path
    }
}
