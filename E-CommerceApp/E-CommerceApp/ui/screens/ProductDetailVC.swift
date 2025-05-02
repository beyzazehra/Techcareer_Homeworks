import UIKit

class ProductDetailVC: UIViewController {

    var incomingItem: Product?
    private var quantity = 1

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonShadow()
        productImage.image = UIImage(named: incomingItem?.image ?? "")
        productName.text = incomingItem?.name
        productPrice.text = "₺\(incomingItem?.price ?? 0)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func decraseQuantity(_ sender: Any) {
        if quantity > 1 {
                quantity -= 1
                quantityLabel.text = "\(quantity)"
            }
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let item = incomingItem else { return } // incomingItem -> Product
            let selectedQuantity = self.quantity // kullanıcının seçtiği adet

            let cartItem = Cart(from: item, quantity: selectedQuantity, username: "beyzazehra")

            APIService.shared.addToCart(cartItem: cartItem) { result in
                switch result {
                case .success(let value):
                    print("✅ Sepete eklendi: \(value)")
                case .failure(let error):
                    print("❌ Hata: \(error.localizedDescription)")
                }
            }

            performSegue(withIdentifier: "goToCart", sender: cartItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCart",
           let destinationVC = segue.destination as? CartVC,
           let productToSend = sender as? Product {
            destinationVC.incomingItem = productToSend
        }
    }

    private func configureButtonShadow() {
        let customColor = UIColor(red: 207/255, green: 255/255, blue: 105/255, alpha: 1.0)
        addToCartButton.setTitle("Sepete Ekle", for: .normal)
        addToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addToCartButton.tintColor = .black
        addToCartButton.layer.shadowColor = customColor.cgColor
        addToCartButton.layer.shadowOpacity = 0.8
        addToCartButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addToCartButton.layer.shadowRadius = 6
        addToCartButton.layer.masksToBounds = false
    }
}

