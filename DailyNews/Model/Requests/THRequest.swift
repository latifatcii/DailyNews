import Foundation

struct THRequest: Codable {
    let country: String?
    let category: THCategories?
    let qWord: String?
    let pageSize: Int?
    let page: Int?
}
enum THCategories: String, Codable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}
