import UIKit

class chatViewCell: UITableViewCell {

    @IBOutlet weak var celda: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var mensage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
