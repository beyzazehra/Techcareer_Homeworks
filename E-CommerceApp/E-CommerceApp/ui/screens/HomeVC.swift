import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarToggleButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tumuButton: UIButton!
    @IBOutlet weak var aksesuarButton: UIButton!
    @IBOutlet weak var kozmetikButton: UIButton!
    @IBOutlet weak var teknolojiButton: UIButton!
    
    var allProducts: [Product] = []
    var products: [Product] = []
    var selectedItem: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        configureSearchBar()
        setupButtons()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }

    func fetchProducts() {
        APIService.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.allProducts = products
                self?.products = products
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureSearchBar() {

        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1)

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {

            textField.backgroundColor = .white
            textField.layer.cornerRadius = 20
            textField.clipsToBounds = true
            textField.textColor = .black

            textField.attributedPlaceholder = NSAttributedString(
                string: "Ara...",
                attributes: [.foregroundColor: UIColor.systemGray]
            )

            textField.leftView = nil
        }
        
        let image = getImageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: 50))
        searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        
        func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
               let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
               UIGraphicsBeginImageContextWithOptions(size, false, 0)
               color.setFill()
               UIRectFill(rect)
               let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
               UIGraphicsEndImageContext()
               return image
           }
        searchBar.isHidden = true
        searchBarHeightConstraint.constant = 0
    }
    
    func filterProducts(with keyword: String) {
        if keyword.isEmpty {
            products = allProducts
        } else {
            products = allProducts.filter {
                $0.name!.lowercased().contains(keyword.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    @IBAction func toggleSearchBar(_ sender: Any) {
        
        let willShow = searchBarHeightConstraint.constant == 0

        searchBar.isHidden = false
        searchBarHeightConstraint.constant = willShow ? 50 : 0

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.searchBar.isHidden = !willShow
        })
    }

    @IBAction func navigateToCartVC(_ sender: Any) {
    }

    @IBAction func tumuButton(_ sender: Any) {
        
        resetButtonColors()
        styleButton(tumuButton)
        filterProducts(by: "tumu")
    }
    
    @IBAction func aksesuarButton(_ sender: Any) {
        
        resetButtonColors()
        styleButton(aksesuarButton)
        filterProducts(by: "Aksesuar")
    }
    
    @IBAction func kozmetikButton(_ sender: Any) {
        
        resetButtonColors()
        styleButton(kozmetikButton)
        filterProducts(by: "Kozmetik")
    }
    
    @IBAction func teknolojiButton(_ sender: Any) {
        
        resetButtonColors()
        styleButton(teknolojiButton)
        filterProducts(by: "Teknoloji")
    }
    
    func filterProducts(by category: String) {
        if category == "tumu" {
            products = allProducts
        } else {
            products = allProducts.filter { $0.category == category }
        }
        collectionView.reloadData()
    }

    func setupButtons() {
        let buttons = [tumuButton, aksesuarButton, kozmetikButton, teknolojiButton]
        
        for button in buttons {
            button?.layer.cornerRadius = 16
            button?.clipsToBounds = true
            button?.backgroundColor = .white
            button?.setTitleColor(.black, for: .normal)
        }
        tumuButton?.backgroundColor = UIColor(red: 207/255, green: 255/255, blue: 105/255, alpha: 1.0)
    }

    func resetButtonColors() {
        let buttons = [tumuButton, aksesuarButton, kozmetikButton, teknolojiButton]
        
        for button in buttons {
            button?.backgroundColor = .white
        }
    }

    func styleButton(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 207/255, green: 255/255, blue: 105/255, alpha: 1.0)
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let product = products[indexPath.row]

        cell.configure(with: product)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = products[indexPath.row]
        performSegue(withIdentifier: "goToProductDetail", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProductDetail" {
            let destinationVC = segue.destination as! ProductDetailVC
            destinationVC.incomingItem = selectedItem
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2.0 - 20, height: 270)
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProducts(with: searchText)
    }
}
