//
//  ApiManager.swift
//

import Alamofire

private var host = ""

public struct ApiManager {
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        //print("Host: \(host)")
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            host: .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    public init(path: String, method: HTTPMethod = .post, parameters: Parameters = [:]) {
        url = path
        host = url.components(separatedBy: "/")[2]
        self.method = method
        self.parameters = parameters
    }
    
    public func request(success: @escaping (_ data: Dictionary<String, Any>)-> Void, fail: @escaping (_ error: Error?)-> Void) {
        ApiManager.Manager.request(url, method: method, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            }else{
                fail(response.result.error)
            }
        }
    }
}
