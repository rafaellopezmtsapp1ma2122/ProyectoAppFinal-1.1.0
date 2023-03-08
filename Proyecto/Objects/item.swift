import Foundation
import UIKit

class Item {
    
    // Variables del Item
    public let nameObj: String
    public let text: String
    public let priceObj: Int
    public let stringPrice: String
    public let imagenObj: String
    public let tagsObj: String
    public let user: String
    public var fav: Bool
    
    // Inicialización de las variables
    init(json: [String: Any]){
        nameObj = json["name"] as? String ?? "None"
        text = json["description"] as? String ?? "Without description"
        imagenObj = json["image"] as? String ?? ""
        tagsObj = json["tags"] as? String ?? "Empty"
        priceObj = json["price"] as? Int ?? 0
        stringPrice = String(priceObj) + "€"
        user = json["user"] as? String ?? ""
        fav = false
        
        
    }
}
