import Alamofire
import Foundation

class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    private let baseUrl = "http://kasimadalan.pe.hu/urunler"
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let url = "\(baseUrl)/tumUrunleriGetir.php"
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let productResponse):
                    completion(.success(productResponse.urunler))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addToCart(cartItem: Cart, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        let parameters: [String: Any] = [
            "ad": cartItem.name ?? "",
            "resim": cartItem.image ?? "",
            "kategori": cartItem.category ?? "",
            "fiyat": cartItem.price ?? 0,
            "marka": cartItem.brand ?? "",
            "siparisAdeti": cartItem.quantity ?? 1,
            "kullaniciAdi": cartItem.username ?? ""
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func fetchCartItems(username: String, completion: @escaping (Result<[Cart], Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        let parameters: [String: Any] = [
            "kullaniciAdi": username
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: CartResponse.self) { response in
                switch response.result {
                case .success(let cartResponse):
                    if cartResponse.success == 1 {
                        completion(.success(cartResponse.urunler_sepeti))
                    } else {
                        let message = cartResponse.message ?? "Sepette ürün bulunamadı"
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func removeFromCartFull(cartItem: Cart, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let parameters: [String: Any] = [
            "sepetId": cartItem.id ?? "",
            "kullaniciAdi": "beyzazehra"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

