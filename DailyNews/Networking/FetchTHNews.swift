import UIKit


class FetchTopHeadline {
    static let shared = FetchTopHeadline()
    let cache = NSCache<NSString, UIImage>()

    
    func fetchData(_ from: THRequest, completion: @escaping (Result<THNews,Error>) -> Void) {
        
        guard let page = from.page else { return }
        guard let country = from.country else { return }
        guard let pageSize = from.pageSize else { return }
        
        let endpoint = EndPointType().TopHeadline + "?apiKey=ff5f1bcd02d643f38454768fbc539040&country=\(country)&pageSize=\(pageSize)&page=\(page)"
        
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
}
