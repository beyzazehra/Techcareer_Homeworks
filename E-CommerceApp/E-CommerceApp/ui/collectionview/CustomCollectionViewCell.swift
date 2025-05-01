import UIKit
import Alamofire

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
    
    func configure(with product: Product) {
        productNameLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0) ₺"
        
        let imageUrl = product.imageURL
        AF.request(imageUrl).responseData { response in
            switch response.result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print("Resim yükleme hatası: \(error)")
            }
        }
    }
}
