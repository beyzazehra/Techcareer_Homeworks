import UIKit
import Alamofire

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var favProductName: UILabel!
    @IBOutlet weak var favProductPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with product: Product) {
        favProductName.text = product.name
        favProductPrice.text = "₺\(product.price ?? 0)"
        let imageUrl = product.imageURL
        AF.request(imageUrl).responseData { response in
            switch response.result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.favImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print("Resim yükleme hatası: \(error)")
            }
        }
    }
}
