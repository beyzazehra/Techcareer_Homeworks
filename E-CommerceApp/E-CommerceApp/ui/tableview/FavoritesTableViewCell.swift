import UIKit
import Alamofire

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var favProductName: UILabel!
    @IBOutlet weak var favProductPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with product: Product) {
        favProductName.text = product.name
        favProductPrice.text = "₺\(product.price ?? 0)"
        if let urlString = product.imageURL, let url = URL(string: urlString) {
            favImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
}
