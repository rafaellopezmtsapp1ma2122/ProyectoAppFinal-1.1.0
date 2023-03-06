import Foundation

class Forum: Codable{
    
    public let nameUser: String
    public let mensaje: String

   
    init(json: [String: Any]){

        nameUser = json["name"] as? String ?? ""
        mensaje = json["mensaje"] as? String ?? ""
       
    }
}
