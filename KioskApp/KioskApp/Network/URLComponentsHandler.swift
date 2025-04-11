import Foundation

final class URLComponentHandler {
    func fetchURLComponents(brand: Brand? = nil,
                            category: Category? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        
        let owner = "Sparta-bootcamp-master-1team"
        let repo = "KioskStorage"
        var paths: [String] = []
        paths = ["repos", owner, repo, "contents"]
        
        guard let brand = brand?.rawValue,
              let category = category?.rawValue
        else {
            return components
        }
        
        paths.append(brand)
        paths.append(category)
        
        components.path = "/" + "\(paths.joined(separator: "/"))"
        return components
    }
}
