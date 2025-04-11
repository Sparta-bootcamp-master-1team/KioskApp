import Foundation

enum DataError: Error {
    case fileNotFound
    case parsingFailed
}

class DataService {
    func fetchData(completion: @escaping (Result< [Beverage], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "Beverages", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let response = try JSONDecoder().decode([Beverage].self, from: data)
            completion(.success(response))
        } catch {
            print("JSON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}
