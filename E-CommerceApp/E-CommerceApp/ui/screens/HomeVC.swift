import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var searchBarToggleButton: UIButton!
    
    @IBOutlet weak var cartButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let data: [Product] = [
        Product(id: 1, name: "iPhone 14", image: "telefon", brand: "Apple", category: "Smartphone", price: 49999),
        Product(id: 2, name: "Galaxy S24", image: "telefon", brand: "Samsung", category: "Smartphone", price: 44999),
        Product(id: 3, name: "MacBook Air", image: "telefon", brand: "Apple", category: "Laptop", price: 69999),
        Product(id: 4, name: "PlayStation 5", image: "telefon", brand: "Sony", category: "Gaming", price: 23999),
        Product(id: 5, name: "AirPods Pro", image: "telefon", brand: "Apple", category: "Accessories", price: 8499)
    ]
    var selectedItem: Product?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
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
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let product = data[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.priceLabel.text = "\(product.price) ₺"
        cell.imageView.image = UIImage(named: product.image)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = data[indexPath.row]
        performSegue(withIdentifier: "goToProductDetail", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProductDetail" {
            let destinationVC = segue.destination as! ProductDetailVC
            destinationVC.item = selectedItem
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2.0 - 20, height: 270)
    }
}
