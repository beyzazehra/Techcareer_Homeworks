import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var onQuantityChanged: ((Int) -> Void)?
    private var quantity = 1
    
    func configure(with product: Cart) {
        productName.text = product.name
        productPrice.text = "₺\(product.price ?? 0)"
        quantity = product.quantity ?? 1
        quantityLabel.text = "\(quantity)"
        
        if let urlString = product.imageURL, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        onQuantityChanged?(quantity)
    }
    
    @IBAction func minusTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            onQuantityChanged?(quantity)
        } else {
            onQuantityChanged?(0)
        }
    }
}
