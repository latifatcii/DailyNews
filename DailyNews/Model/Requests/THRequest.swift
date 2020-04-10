import Foundation

struct THRequest {
    let country: String?
    let category: THCategories?
    let qWord: String?
    let pageSize: Int?
    let page: Int?
}
enum THCategories {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}
