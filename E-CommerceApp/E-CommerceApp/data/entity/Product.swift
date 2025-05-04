import Foundation

struct Product: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let category: String?
    let price: Int?
    let brand: String?
    var quantity: Int?
    var isFavorite: Bool = false
    var imageURL: String? {
        guard let image = image else { return nil }
        return "http://kasimadalan.pe.hu/urunler/resimler/\(image)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
    }
}
