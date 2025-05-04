import UIKit
import Alamofire
import Lottie

class ProductDetailVC: UIViewController {

    var incomingItem: Product?
    private var quantity = 1

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToFavsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonShadow()
        configProductViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        checkIfFavorite()
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToFavs(_ sender: Any) {
        guard let item = incomingItem, let id = item.id else { return }

        var favorites = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] ?? []
            
            if favorites.contains(id) {
                favorites.removeAll { $0 == id }
                incomingItem?.isFavorite = false
            } else {
                favorites.append(id)
                incomingItem?.isFavorite = true
            }
            
            UserDefaults.standard.set(favorites, forKey: "favoriteIDs")
            
            updateFavoriteIcon()
    }


    func updateFavoriteIcon() {
        guard let item = incomingItem, let id = item.id else { return }
        let favoriteIDs = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] ?? []
        let imageName = favoriteIDs.contains(id) ? "heart.fill" : "heart"
        addToFavsButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func checkIfFavorite() {
        guard let item = incomingItem, let id = item.id else { return }
        let favorites = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] ?? []
        incomingItem!.isFavorite = favorites.contains(id)
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
        guard let item = incomingItem else { return }
            
        let selectedQuantity = self.quantity
        let cartItem = Cart(from: item, quantity: selectedQuantity, username: "beyzazehra")

        APIService.shared.fetchCartItems(username: "beyzazehra") { [weak self] result in
                switch result {
                case .success(let products):
                    var oldProduct = products.first(where: { $0.name == item.name })
                    if oldProduct != nil {
                        oldProduct?.quantity! += selectedQuantity
                        APIService.shared.updateCart2(cartItem: oldProduct!) { result in
                            switch result {
                            case .success(let value):
                                print("Sepete eklendi: \(value)")
                                self?.showLottieAnimation {
                                    self?.performSegue(withIdentifier: "goToCart", sender: cartItem)
                                }

                            case .failure(let error):
                                print("Hata: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        APIService.shared.addToCart(cartItem: cartItem) { result in
                            switch result {
                            case .success(let value):
                                print("Sepete eklendi: \(value)")
                                self?.showLottieAnimation {
                                    self?.performSegue(withIdentifier: "goToCart", sender: cartItem)
                                }
                            case .failure(let error):
                                print("Hata: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching products: \(error.localizedDescription)")
                }
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
    
    func configProductViews() {
        
        if let name = incomingItem?.name, let brand = incomingItem?.brand {
            productName.text = "\(brand)\n\(name)"
        }
        
        productPrice.text = "₺\(incomingItem?.price ?? 0)"
        
        let imageUrl = incomingItem?.imageURL
        AF.request(imageUrl!).responseData { response in
            switch response.result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.productImage.image = UIImage(data: data)
                }
            case .failure(let error):
                print("Resim yükleme hatası: \(error)")
            }
        }
    }
    
    func showLottieAnimation(completion: @escaping () -> Void) {
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.isUserInteractionEnabled = false

        let animationView = LottieAnimationView(name: "Animation - 1746358204055")
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = overlayView.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        overlayView.addSubview(animationView)
        self.view.addSubview(overlayView)

        animationView.play { finished in
            overlayView.removeFromSuperview()
            completion()
        }
    }
}

