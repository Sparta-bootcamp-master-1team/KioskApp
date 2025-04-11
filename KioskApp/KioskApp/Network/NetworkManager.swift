import Foundation

enum NetworkError: Error {
    case decodingError
    case serverError(code: Int)
    case missingData
    case invalidURL
    case transportError
    
    var customLocalizedDescription: String {
        switch self {
        case .decodingError:
            return "Decoding Error"
        case .serverError(code: let code):
            return "Server Error (\(code))"
        case .missingData:
            return "Missing Data"
        case .invalidURL:
            return "Invalid URL"
        case .transportError:
            return "Transport Error"
        }
    }
}

enum NetworkSequence {
    static let array: [(brand: Brand, category: Category)] =
    [
        (.paik, .dessert),
        (.paik, .coffeeHot),
        (.paik, .coffeeIce),
        (.paik, .beverageHot),
        (.paik, .beverageIce),
        (.theVenti, .dessert),
        (.theVenti, .coffeeHot),
        (.theVenti, .coffeeIce),
        (.theVenti, .beverageHot),
        (.theVenti, .beverageIce),
        (.mega, .dessert),
        (.mega, .coffeeHot),
        (.mega, .coffeeIce),
        (.mega, .beverageHot),
        (.mega, .beverageIce),
    ]
}

final class NetworkManager {
    
    private let session = URLSession(configuration: .default)
    private let urlComponenetHandler = URLComponentHandler()
    
    func fetchData<T: Decodable>(for type: T.Type ,
                                 brand: Brand? = nil,
                                 category: Category? = nil) async throws -> T {
        let urlComponents = urlComponenetHandler.fetchURLComponents(brand: brand, category: category)
        
        guard let url = urlComponents.url else {
            throw(NetworkError.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let response = try await session.data(for: urlRequest)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw(NetworkError.transportError)
        }
        let successRange = 200..<300
        guard successRange.contains(httpResponse.statusCode) else {
            let code = httpResponse.statusCode
            throw(NetworkError.serverError(code: code))
        }
        
        guard let response = try? JSONDecoder().decode(T.self, from: response.0) else {
            throw(NetworkError.decodingError)
        }
        
        return response
    }
}
