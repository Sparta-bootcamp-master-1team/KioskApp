import UIKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private init() {}
    
    var cache = NSCache<NSString, UIImage>()
    
    func image(from urlPath: String) async throws {
        let urlNSString = NSString(string: urlPath)
        if let image = cache.object(forKey: urlNSString) {
            return
        }
        guard let url = URL(string: urlPath) else {
            throw(NetworkError.invalidURL)
        }
        
        let session = URLSession(configuration: .ephemeral)
        let response = try await session.data(from: url)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw(NetworkError.transportError)
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw(NetworkError.serverError(code: httpResponse.statusCode))
        }
        guard let image = UIImage(data: response.0) else {
            throw(NetworkError.decodingError)
        }
        
        cache.setObject(image, forKey: urlNSString)
    }
    
    func fetchImage(from urlPath: String) async throws -> UIImage? {
        let urlNSString = NSString(string: urlPath)
        if let image = cache.object(forKey: urlNSString) {
            return image
        }
        guard let url = URL(string: urlPath) else {
            throw(NetworkError.invalidURL)
        }
        
        let session = URLSession(configuration: .ephemeral)
        let response = try await session.data(from: url)
        
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw(NetworkError.transportError)
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw(NetworkError.serverError(code: httpResponse.statusCode))
        }
        guard let image = UIImage(data: response.0) else {
            throw(NetworkError.decodingError)
        }
        
        cache.setObject(image, forKey: urlNSString)
        return image
    }
    
}
