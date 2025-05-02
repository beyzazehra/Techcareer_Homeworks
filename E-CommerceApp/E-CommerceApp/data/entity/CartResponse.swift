import Foundation

struct CartResponse: Codable {
    let urunler_sepeti: [Cart]
    let success: Int
    let message: String?
}
