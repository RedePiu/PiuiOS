import UIKit
import Alamofire
import ObjectMapper

class DataParser: NSObject, URLSessionTaskDelegate {
    
    func jsonSerialization(from jsonString: String) {
        
        let jsonData = jsonString.data(using: .utf8) ?? Data()
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(
                with: jsonData,
                options: []
            ) as! [String:Any]
            
            
        } catch {
            print("@! >>> ERROR: ", error)
        }
    }
    
    func mainParser<T: Mappable>(
        url: URL,
        body: Data,
        method: HTTPMethod,
        completion: @escaping ((MainResponse<T>) -> Void)
    ) {
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(integerLiteral: 30)
        request.httpBody = body
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = [:]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            Alamofire.request(request).response { (response) in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    return
                }
                
                print("@! >>> Status code da requisição de \(url): ", statusCode)
                
                if statusCode == 200 {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    
                    guard let item = responseJSON as? [String:Any] else {
                        return
                    }
                    
                    let model = Mapper<T>().map(JSON: item)
                    completion(.success(model: model!))
                } else {
                    print(error?.localizedDescription ?? "Não conseguimos receber os dados da API...")
                }
            }
        }
        task.resume()
    }
}
