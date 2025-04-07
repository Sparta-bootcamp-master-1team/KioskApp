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
    
    var imageString: String {
        return "\(self.category)" + "\(self.option)" + "\(self.name)"
    }
}
