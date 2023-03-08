import Foundation

class Favorite: Codable {
    
    //Variables de los objetos favoritos
    public let nameObjFav: String
    public let userFav: String
    public var bool: Bool
    
    //Inicialización de los objetos favoritos
    init(json: [String: Any]){
        nameObjFav = json["name"] as? String ?? "None"
        userFav = json["user"] as? String ?? ""
        bool = false
    }
}
