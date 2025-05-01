import UIKit

class CustomTableViewCell: UITableViewCell {

  
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onQuantityChanged: ((Int) -> Void)?
        private var quantity = 1

        func configure(with product: Product) {
            productName.text = product.name
            productPrice.text = "₺\(product.price ?? 0)"
            productImageView.image = UIImage(named: product.image ?? "")
            quantity = product.quantity ?? 1
            quantityLabel.text = "\(quantity)"
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
