import Foundation

struct EndPointTypee {
    let topHeadline = "https://newsapi.org/v2/top-headlines"
    let everything = "https://newsapi.org/v2/everything"
    let sourcesResponses = "https://newsapi.org/v2/sources"
}

enum EndPointType: String {
    case topHeadline = "/v2/top-headlines"
    case everything = "/v2/everything"
    case sources = "/v2/sources"
}

