import Foundation

struct ENews: Codable {
    let status: String
    let totalResults: Int
    let articles: [EArticle]
}
