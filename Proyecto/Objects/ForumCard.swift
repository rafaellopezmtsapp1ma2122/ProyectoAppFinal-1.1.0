import Foundation
import UIKit

class ForumCard: Codable{
    
    //Variables de los foros
    public var nameForum: String
    public let numero: Int
    public let imagen: String
   
    //Inicialización de los foros
    init(json: [String: Any]){
        imagen = json["image"] as? String ?? ""
        nameForum = json["name"] as? String ?? ""
        numero = json["participants"] as? Int ?? 0
        
    }
}
