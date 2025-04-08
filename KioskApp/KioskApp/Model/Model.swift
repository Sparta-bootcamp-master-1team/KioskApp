import Foundation

struct Product: Decodable {
    let beverage: [Beverage]
}

struct Beverage: Decodable {
    let name: String
    let price: Int
    let category: String
    let option: String?
    let brand: String
    
    var imageName: String {
        return "\(category)" + "\(option == nil ? "-" : "\(option!)-")" + "\(name)" + "-\(brand)"
    }
}
