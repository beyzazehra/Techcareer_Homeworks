import UIKit

class ProductDetailVC: UIViewController {

    var item: Product?
    
    @IBOutlet weak var productImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        productImage.image = UIImage(named: item?.image ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
}
