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
    
    var displayName: String {
        switch self {
        case .mega: return "메가커피"
        case .paik: return "빽다방"
        case .theVenti: return "더벤티"
        }
    }
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
struct OrderItem: Equatable {
    let name: String
    let price: Int
    let brand: Brand
    let category: Category
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
    
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.brand == rhs.brand && lhs.count == rhs.count && lhs.category == rhs.category
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
