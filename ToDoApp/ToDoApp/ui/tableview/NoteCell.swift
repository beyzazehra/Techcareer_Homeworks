import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteCellTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
