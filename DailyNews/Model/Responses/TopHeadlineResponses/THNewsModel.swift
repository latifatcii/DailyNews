import Foundation

struct THNewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [THArticleModel]
}
