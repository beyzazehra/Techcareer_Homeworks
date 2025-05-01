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
}
