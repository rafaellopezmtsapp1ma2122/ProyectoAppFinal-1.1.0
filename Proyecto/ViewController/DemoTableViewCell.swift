import UIKit

class DemoTableViewCell: UITableViewCell {
   
    //Referenciamos los elementos del diseño en codigo para su posterior uso
    
    static var name: String?
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var objImage: UIImageView!
    
    @IBOutlet weak var objName: UILabel!
    
    @IBOutlet weak var objTags: UILabel!
    
    @IBOutlet weak var objPrice: UILabel!
    
    @IBOutlet weak var favItem: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        objTags.layer.masksToBounds = true
        objTags.layer.cornerRadius = 10
    }

}
