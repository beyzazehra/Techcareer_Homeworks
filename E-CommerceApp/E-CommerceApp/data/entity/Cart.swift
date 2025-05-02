import Foundation

struct Cart: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let category: String?
    let price: Int?
    let brand: String?
    var quantity: Int?
    var username: String?
    var imageURL: String {
            guard let image = image else { return "" }
            return "http://kasimadalan.pe.hu/urunler/resimler/\(image)"
        }

    enum CodingKeys: String, CodingKey {
        case id = "sepetId"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
        case quantity = "siparisAdeti"
        case username = "kullaniciAdi"
    }
}

extension Cart {
    init(from product: Product, quantity: Int, username: String) {
        self.id = product.id
        self.name = product.name
        self.image = product.image
        self.category = product.category
        self.price = product.price
        self.brand = product.brand
        self.quantity = quantity
        self.username = username
    }
}
