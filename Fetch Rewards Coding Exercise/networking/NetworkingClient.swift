import Alamofire
import Foundation
import SwiftyJSON

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return sharedInstance.isReachable
    }
}

class NetworkingClient {
    typealias ApiResponse = (JSON?, Error?) -> Void

    func execute(url: URL, completion: @escaping ApiResponse) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        AF.request(url).validate().responseJSON(queue: utilityQueue) { response in
            switch response.result {
            case let .success(value):
                let jsonResponse = JSON(value)
                completion(jsonResponse, nil)
            case let .failure(error):
                print("Request failed with error: \(error)")
                completion(nil, error)
            }
        }
    }
}
