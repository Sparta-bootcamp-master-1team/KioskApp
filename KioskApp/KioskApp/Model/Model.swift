import Foundation

/// 카테고리 (Coffee, Beverage, Desert)
enum Category: String, Decodable {
    case coffee = "Coffee"
    case beverage = "Beverage"
    case desert = "Desert"
}

/// 3사 브랜드 (Baik, TheVenti, Mega)
enum Brand: String, Decodable {
    case baik = "Baik"
    case theVenti = "TheVenti"
    case mega = "Mega"
}

/// 커피와 음료의 옵션, 디저트는 none  (HOT, ICE, none)
enum Option: String, Decodable{
    case hot = "HOT"
    case ice = "ICE"
}

/// 모든 브랜드의 커피 배열을 담은 구조체
struct Product: Decodable {
    let beverage: [Beverage]
    
    var baiksProduct: [Beverage] {
        return beverage.filter {
            $0.brand == .baik
        }
    }
    
    var theVentiProduct: [Beverage] {
        return beverage.filter {
            $0.brand == .theVenti
        }
    }
    var megaProduct: [Beverage] {
        return beverage.filter {
            $0.brand == .mega
        }
    }
    
    func fetchData(brand: Brand,
                   category: Category,
                   option: Option? = nil) -> [Beverage] {
        return beverage.filter {
            $0.category == category &&
            $0.brand == brand &&
            $0.option == option
        }
    }
    
    func fecthRecommendedData(brand: Brand,
                              category: Category,
                              option: Option? = nil) -> [Beverage] {
        return self.fetchData(brand: brand, category: category, option: option).filter{ $0.recommended == true }
    }
}

/// 제품 하나의 세부정보 리스트
struct Beverage: Decodable {
    let name: String
    let price: Int
    let category: Category
    let option: Option?
    let brand: Brand
    var recommended: Bool?
    var imageName: String {
        return "\(category)" + "\(option == nil ? "-" : "\(option!)-")" + "\(name)" + "-\(brand)"
    }
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
