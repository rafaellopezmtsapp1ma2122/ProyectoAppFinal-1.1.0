import UIKit

class forumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cardForum: UIView!
    

    @IBOutlet weak var imagenForm: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var num: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
