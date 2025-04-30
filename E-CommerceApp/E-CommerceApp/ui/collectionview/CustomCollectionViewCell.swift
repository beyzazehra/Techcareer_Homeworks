import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addFavoriteButton: UIButton!
   
    override func awakeFromNib() {
            super.awakeFromNib()
            // ImageView yuvarlak yapma
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
        }
}
