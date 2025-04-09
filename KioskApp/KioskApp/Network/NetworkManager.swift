import Foundation

enum NetworkError: Error {
    case decodingError
    case serverError(code: Int)
    case missingData
    case invalidURL
    case transportError
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
        
        var urlRequest = URLRequest(url: urlComponents.url!)
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
