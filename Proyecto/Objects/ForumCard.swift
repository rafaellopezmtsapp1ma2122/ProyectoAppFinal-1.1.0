import Foundation
import UIKit

class ForumCard: Codable{
    
    public var nameForum: String
    public let numero: String
    public let imagen: String
   
    init(json: [String: Any]){
        imagen = json["image"] as? String ?? ""
        nameForum = json["name"] as? String ?? ""
        numero = json["participants"] as? String ?? ""
        
    }
}
