import Foundation

final class DataProvider {
    
    private let networkManager: NetworkManager
    private let dataService: DataService
    
    init(networkManager: NetworkManager = .init(), dataService: DataService = .init()) {
        self.networkManager = networkManager
        self.dataService = dataService
    }
    
//     Beverage.json으로 부터 데이터 불러오기
    private func configureBeverage() -> [Beverage] {
        let dataService = DataService()
        var items: [Beverage] = []
        dataService.fetchData { result in
            switch result {
            case .success(let success):
                items = success
            case .failure(let failure):
                print(failure)
            }
        }
        return items
    }
    
//     Git KioskStorage의 이미지파일들 모두 불러오기 (병렬 처리)
    private func configureNetworkResponse() async throws -> [NetworkResponse] {
        var responses: [NetworkResponse] = []
        try await withThrowingTaskGroup(of: [NetworkResponse].self) {[weak self] group in
            guard let self else { return }
            for i in 0..<NetworkSequence.array.count {
                let brand = NetworkSequence.array[i].brand
                let category = NetworkSequence.array[i].category
                group.addTask {
                    return try await self.networkManager.fetchData(for: [NetworkResponse].self,
                                                                   brand: brand,
                                                                   category: category)
                }
            }
            for try await response in group {
                responses += response
            }
        }
        return responses
    }
    
//     불러온 이미지 캐시에 저장
    private func configureCache(response: [NetworkResponse]) async throws {
        try await withThrowingTaskGroup(of: (Void).self) {[weak self] group in
            guard let self else { return }
            for i in 0..<response.count {
                group.addTask {
                    return try await ImageCacheManager.shared.image(from: response[i].downloadURL ?? "")
                }
            }
            for try await _ in group { }
        }
    }
    
//     Beverage의 ImageName에 이미지 URL 할당
    private func assignImageURL(from response: [NetworkResponse], to beverages: inout [Beverage]) {
        for i in 0..<response.count {
            let arr = response[i].name.split(separator: ".")
            let name = arr.first ?? ""
            
            
            guard let path = response[i].path?.split(separator: "/") else { continue }
            let brand = String(path[0])
            let category = String(path[1])
            
            for j in 0..<beverages.count {
                if beverages[j].name == name &&
                    beverages[j].brand.rawValue == brand &&
                    beverages[j].category.rawValue == category {
                    beverages[j].imageName = response[i].downloadURL
                }
            }
        }
    }
    
//    데이터 준비 프로세스
//    1. Beverage.json 데이터 파싱
//    2. Git Repo의 이미지 불러오기
//    3. 불러온 이미지 캐시 저장
//    4. Beverage의 ImageName에 이미지 URL 저장
//    탈출 클로저로 준비된 데이터를 전달
    func process(/*completion: @escaping ([Beverage]) -> Void*/) async throws-> [Beverage] {
        var beverages = configureBeverage()
        guard let response = try? await configureNetworkResponse() else {
            throw(NetworkError.transportError)
        }
        
        guard let _ = try? await configureCache(response: response) else {
            throw(NetworkError.transportError)
        }
        assignImageURL(from: response, to: &beverages)
        return beverages
    }
}
