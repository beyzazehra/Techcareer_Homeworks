import Foundation

struct ProductResponse: Codable {
    let urunler: [Product]
    let success: Int
    let message: String?
}
