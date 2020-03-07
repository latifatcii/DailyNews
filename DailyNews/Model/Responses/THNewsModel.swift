
struct THNews: Codable {
    let status: String
    let totalResults: Int
    let articles: [THArticle]
}
