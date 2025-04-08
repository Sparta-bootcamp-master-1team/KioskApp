import Foundation

enum Category: String, Decodable {
    case Coffee
    case Beverage
    case Desert
}

enum Brand: String, Decodable {
    case Baik
    case TheVenti
    case Mega
}

enum Option: String, Decodable{
    case HOT
    case ICE
}

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
