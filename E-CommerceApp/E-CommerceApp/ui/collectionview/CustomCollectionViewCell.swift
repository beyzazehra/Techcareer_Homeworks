import UIKit
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    func configure(with product: Product) {
        productNameLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0) ₺"
        
        if let urlString = product.imageURL, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
}
