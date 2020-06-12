import Foundation

struct ENewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [EArticleModel]
}
