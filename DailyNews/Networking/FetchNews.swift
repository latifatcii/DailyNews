import Foundation
import RxSwift

protocol FetchNewsProtocol {
    func fetchTopHeadlineNews(_ from: THRequest, completion: @escaping (Result<THNews, Error>) -> Void)
    func fetchDataForSearchController(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void)
    func fetchNewsFromEverything( _ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void)
    func fetchSources(_ from: SRequest, completion: @escaping (Result<SourcesModel, Error>) -> Void)
    func fetchNewsWithSources(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void)
}

class FetchNews: FetchNewsProtocol {
    static let shared = FetchNews()
    
    func fetchTopHeadlineNews(_ from: THRequest, completion: @escaping (Result<THNews, Error>) -> Void) {
        
        guard let page = from.page, let country = from.country, let pageSize = from.pageSize, let category = from.category else { return }
        
        let params: [String:Any] = ["country" : country, "pageSize": pageSize, "page": page, "category": category]
        
        deneme(params: params, endpointType: EndPointType().topHeadline , completion: completion)
    }

    
    func fetchDataForSearchController(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let qWord = from.qWord else { return }
        let params: [String:Any] = ["page" : page, "pageSize": pageSize, "language": language, "qWord": qWord]
        
        deneme(params: params, endpointType: EndPointType().everything , completion: completion)
    }
    
    func fetchNewsFromEverything( _ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let sources = from.sources, let sortBy = from.sortBy
            else { return }
        
        let params: [String:Any] = ["page" : page, "pageSize": pageSize, "language": language, "sources": sources, "sortBy": sortBy]
        
        deneme(params: params, endpointType: EndPointType().everything , completion: completion)
    }
    
    func fetchSources(_ from: SRequest, completion: @escaping (Result<SourcesModel, Error>) -> Void) {
        guard let category = from.category, let language = from.language else { return }
    
        let params: [String:Any] = ["category" : category, "language": language]
        
        deneme(params: params, endpointType: EndPointType().sourcesResponses, completion: completion)
    }
    
    func fetchNewsWithSources(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let sources = from.sources else { return }
        
       let params: [String:Any] = ["sources" : sources, "pageSize": pageSize, "page": page, "language": language]
        
        deneme(params: params,endpointType: EndPointType().everything ,completion: completion)

    }
    
    func deneme<T: Decodable>(params: [String : Any], endpointType: String ,completion: @escaping (Result<T, Error>) -> Void) {
        
        var endpoint = endpointType + "?apiKey=ff5f1bcd02d643f38454768fbc539040"
        
        params.forEach { (key,value) in
            endpoint.append("&\(key)=\(value)")
        }
        
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("error1")
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("invalid response")
                return
            }
            guard let data = data else {
                print("invalid data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let news = try decoder.decode(T.self, from: data)
                completion(.success(news))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
