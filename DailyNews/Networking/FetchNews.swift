//ff5f1bcd02d643f38454768fbc539040
//8937c23c392f4972873b51f17d46d42d
import UIKit


class FetchNews {
    static let shared = FetchNews()
    let cache = NSCache<NSString, UIImage>()
    
    func fetchData(_ from: THRequest, completion: @escaping (Result<THNews,Error>) -> Void) {
        
        guard let page = from.page else { return }
        guard let country = from.country else { return }
        guard let pageSize = from.pageSize else { return }
        guard let category = from.category else { return }
        
        let endpoint = EndPointType().TopHeadline + "?apiKey=8937c23c392f4972873b51f17d46d42d&country=\(country)&pageSize=\(pageSize)&page=\(page)&category=\(category)"
        
        guard let url = URL(string: endpoint) else {
            return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("hata1")
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                print("invalid response")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(THNews.self, from: data)
                completion(.success(news))
                
            } catch {

                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        
        
        
    }
    
    func fetchDataForSearchController(_ from: ERequest, completion: @escaping (Result<ENews,Error>) -> Void) {
        
        guard let page = from.page else { return }
        guard let pageSize = from.pageSize else { return }
        guard let language = from.language else { return }
        guard let q = from.q else { return }
        
        let endpoint = EndPointType().Everything + "?apiKey=8937c23c392f4972873b51f17d46d42d&language=\(language)&pageSize=\(pageSize)&q=\(q)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("hata1")
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                print("invalid response")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(ENews.self, from: data)
                completion(.success(news))
                
            } catch {

                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func fetchNewsFromEverything( _ from : ERequest , completion : @escaping (Result<ENews,Error>) -> Void) {
        
        guard let page = from.page else { return }
        guard let pageSize = from.pageSize else { return }
        guard let language = from.language else { return }
        guard let sources = from.sources else { return }
        guard let sortBy = from.sortBy else { return }
        
        let endpoint = EndPointType().Everything + "?apiKey=8937c23c392f4972873b51f17d46d42d&language=\(language)&pageSize=\(pageSize)&page=\(page)&sources=\(sources)&sortBy=\(sortBy)"
        
        guard let url = URL(string: endpoint) else {
            return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("hata1")
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                print("invalid response")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(ENews.self, from: data)
                completion(.success(news))
                
            } catch {

                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    func fetchSources(_ from : SRequest, completion: @escaping (Result<SourcesModel,Error>) -> Void) {
        
        guard let category = from.category else { return }
        guard let language = from.language else { return }
//        guard let country = from.country else { return }
        
        let endpoint = EndPointType().SourcesRepsonses + "?apiKey=8937c23c392f4972873b51f17d46d42d&category=\(category)&language\(language)"
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("hata1")
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                print("invalid response")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let sources = try decoder.decode(SourcesModel.self, from: data)
                completion(.success(sources))
                
            } catch {

                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func fetchNewsWithSources(_ from : ERequest , completion : @escaping (Result<ENews,Error>) -> Void) {
        guard let page = from.page else { return }
        guard let pageSize = from.pageSize else { return }
        guard let language = from.language else { return }
        guard let sources = from.sources else { return }
//        guard let sortBy = from.sortBy else { return }
        
        let endpoint = EndPointType().Everything + "?apiKey=8937c23c392f4972873b51f17d46d42d&language=\(language)&pageSize=\(pageSize)&page=\(page)&sources=\(sources)"
        
        guard let url = URL(string: endpoint) else {
            return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("hata1")
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                print("invalid response")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(ENews.self, from: data)
                completion(.success(news))
                
            } catch {

                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
