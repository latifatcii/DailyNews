import UIKit

class FetchNews {
    static let shared = FetchNews()
    let cache = NSCache<NSString, UIImage>()
    func fetchData(_ from: THRequest, completion: @escaping (Result<THNews, Error>) -> Void) {
        guard let page = from.page, let country = from.country, let pageSize = from.pageSize, let category = from.category else { return }

        let endpoint = EndPointType().topHeadline + "?apiKey=ff5f1bcd02d643f38454768fbc539040&country=\(country)&pageSize=\(pageSize)&page=\(page)&category=\(category)"

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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(THNews.self, from: data)
                completion(.success(news))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func fetchDataForSearchController(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let qWord = from.qWord else { return }

        let endpoint = EndPointType().everything + "?apiKey=ff5f1bcd02d643f38454768fbc539040&language=\(language)&pageSize=\(pageSize)&q=\(qWord)&page=\(page)"

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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(ENews.self, from: data)
                completion(.success(news))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func fetchNewsFromEverything( _ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let sources = from.sources, let sortBy = from.sortBy
            else { return }

        let endpoint = EndPointType().everything + "?apiKey=ff5f1bcd02d643f38454768fbc539040&language=\(language)&pageSize=\(pageSize)&page=\(page)&sources=\(sources)&sortBy=\(sortBy)"

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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(ENews.self, from: data)
                completion(.success(news))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func fetchSources(_ from: SRequest, completion: @escaping (Result<SourcesModel, Error>) -> Void) {
        guard let category = from.category, let language = from.language else { return }

        let endpoint = EndPointType().sourcesRepsonses + "?apiKey=ff5f1bcd02d643f38454768fbc539040&category=\(category)&language\(language)"

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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let sources = try decoder.decode(SourcesModel.self, from: data)
                completion(.success(sources))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func fetchNewsWithSources(_ from: ERequest, completion: @escaping (Result<ENews, Error>) -> Void) {
        guard let page = from.page, let pageSize = from.pageSize, let language = from.language, let sources = from.sources else { return }

        let endpoint = EndPointType().everything + "?apiKey=ff5f1bcd02d643f38454768fbc539040&language=\(language)&pageSize=\(pageSize)&page=\(page)&sources=\(sources)"

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
