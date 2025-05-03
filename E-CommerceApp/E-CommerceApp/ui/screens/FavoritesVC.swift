import UIKit

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var favsTableView: UITableView!
    
    var favoriteProducts: [Product] = []
    var pros: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favsTableView.delegate = self
        favsTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    func loadFavorites() {
        let favoriteIDs = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] ?? []
        
        APIService.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.pros = products
                self?.favoriteProducts = products.filter { favoriteIDs.contains($0.id ?? -1) }
                self?.favsTableView.reloadData()
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        favsTableView.rowHeight = 140
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritesTableViewCell
        let product = favoriteProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productToRemove = favoriteProducts[indexPath.row]
            
            var favoriteIDs = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] ?? []
            if let id = productToRemove.id {
                favoriteIDs.removeAll { $0 == id }
                UserDefaults.standard.set(favoriteIDs, forKey: "favoriteIDs")
            }
            
            favoriteProducts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }
    
    
}
