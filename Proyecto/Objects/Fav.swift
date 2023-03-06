import Foundation

class Favorite: Codable {
    public let nameObjFav: String
    public let userFav: String
    public var bool: Bool
    
    init(json: [String: Any]){
        nameObjFav = json["name"] as? String ?? "None"
        userFav = json["user"] as? String ?? ""
        bool = false
    }
}
