import Foundation

enum DataError: Error {
    case fileNotFound
    case parsingFailed
}

class DataService {
    func fetchData(completion: @escaping (Result< Product, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "Beverages", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(Product.self, from: data)
            completion(.success(bookResponse))
        } catch {
            print("JSON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}
