import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartItemCountLabel: UILabel!
    
    var cartItems: [Product] = []
    var incomingItem: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        setupTableFooter()
        if let newItem = incomingItem {
            if let index = cartItems.firstIndex(where: { $0.id == newItem.id }) {
                cartItems[index].quantity = (cartItems[index].quantity ?? 0) + (newItem.quantity ?? 0)
            } else {
                cartItems.append(newItem)
            }
        }
        updateCartItemCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        updateCartItemCount()
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateCartItemCount() {
        let totalCount = cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
        cartItemCountLabel.text = "\(totalCount) Ürün"
    }
    
    func setupTableFooter() {
        
        let footerHeight: CGFloat = 200
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: footerHeight))
        footerView.backgroundColor = UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1.0)

        let topLabel = UILabel()
        topLabel.text = "Toplam"
        topLabel.font = UIFont.systemFont(ofSize: 16)
        
        let totalLabel = UILabel()
        totalLabel.text = "₺1234"
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalLabel.textAlignment = .right

        let customColor = UIColor(red: 207/255, green: 255/255, blue: 105/255, alpha: 1.0)
        let payButton = UIButton(type: .system)
        payButton.setTitle("Ödeme Yap", for: .normal)
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        payButton.backgroundColor = .white
        payButton.layer.shadowColor = customColor.cgColor
        payButton.tintColor = .black
        payButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        payButton.layer.shadowRadius = 6
        payButton.layer.shadowOpacity = 0.8
        payButton.layer.cornerRadius = 20
        payButton.layer.borderColor = UIColor.black.cgColor
        payButton.layer.borderWidth = 1.0
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.widthAnchor.constraint(equalToConstant: 245).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        footerView.addSubview(topLabel)
        footerView.addSubview(totalLabel)

        footerView.addSubview(payButton)

        topLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            
            totalLabel.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 24),
            payButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            payButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16)
        ])

        cartTableView.tableFooterView = footerView
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cartTableView.rowHeight = 140
        
        let product = cartItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCartCell", for: indexPath) as! CustomTableViewCell
        cell.configure(with: product)
        cell.onQuantityChanged = { [weak self] newQuantity in
            guard let self = self else { return }
            if newQuantity == 0 {
                self.cartItems.remove(at: indexPath.row)
                self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                return
            } else {
                self.cartItems[indexPath.row].quantity = newQuantity
            }
            self.updateCartItemCount()
        }
        
        return cell
    }
    
    
}
