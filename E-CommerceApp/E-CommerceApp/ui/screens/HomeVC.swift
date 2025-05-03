import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarToggleButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var products: [Product] = []
    var selectedItem: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        fetchProducts()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }

    func fetchProducts() {
        APIService.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
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
