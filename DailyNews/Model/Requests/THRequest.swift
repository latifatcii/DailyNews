import Foundation

struct THRequest : Codable {
    let country : String?
    let category : THCategories?
    let q : String?
    let pageSize : Int?
    let page : Int?
    
    
}

enum THCategories : String , Codable{
    
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
    
}
