import Foundation

/// 카테고리 (Coffee, Beverage, Desert)
enum Category: String, Decodable {
    case Coffee
    case Beverage
    case Desert
}

/// 3사 브랜드 (Baik, TheVenti, Mega)
enum Brand: String, Decodable {
    case Baik
    case TheVenti
    case Mega
}

/// 커피와 음료의 옵션, 디저트는 none  (HOT, ICE, none)
enum Option: String, Decodable{
    case HOT
    case ICE
}

/// 모든 브랜드의 커피 배열을 담은 구조체
struct Product: Decodable {
    let beverage: [Beverage]
    
    var baiksProduct: [Beverage] {
        return beverage.filter { $0.brand == .Baik }
    }
    
    var theVentiProduct: [Beverage] {
        return beverage.filter { $0.brand == .TheVenti }
    }
    var megaProduct: [Beverage] {
        return beverage.filter { $0.brand == .Mega }
    }
    
    func fetchData(brand: Brand, category: Category, option: Option? = nil) -> [Beverage] {
        return beverage.filter { $0.category == category && $0.brand == brand && $0.option == option}
    }
}

/// 제품 하나의 세부정보 리스트
struct Beverage: Decodable {
    let name: String
    let price: Int
    let category: Category
    let option: Option?
    let brand: Brand
    
    var imageName: String {
        return "\(category)" + "\(option == nil ? "-" : "\(option!)-")" + "\(name)" + "-\(brand)"
    }
}
