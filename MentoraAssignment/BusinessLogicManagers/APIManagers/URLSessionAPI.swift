//
//  URLSessionAPI.swift
//  MentoraAssignment
//
//  Created by Lokesh Lebaka on 17/09/22.
//

import Foundation
import UIKit

enum successResponseCode: Int {
    case success = 200
    case failure = -1
}

enum HTTPMethod: Int  {
    case get
    case post
    case patch
    case put
    case delete
}

class URLSessionAPI {
    
    private init() {}
    static let sharedAPI = URLSessionAPI()
    
    private let httpMethodString = ["GET", "POST", "PATCH", "PUT","DELETE"]
    
    func performRequest(urlString : String, type: HTTPMethod, completionHandler: @escaping((statusCode: successResponseCode, response: Any, data: Data?, error: Error?) ) -> ()) {
        
        if let url = URL(string: urlString) {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethodString[type.rawValue]
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }

                if let data = data {
                    do {
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                                completionHandler((statusCode: .success, response: responseObject, data: data, error: error))
                            } else {
                                completionHandler((statusCode: .failure, response: [], data: nil, error: error))
                            }
                        }
                    } catch {
                        completionHandler((statusCode: .failure, response: [], data: nil, error: error))
                    }
                } else {
                    completionHandler((statusCode: .failure, response: [:], data: nil, error: error))
                }
            }
            
            task.resume()
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        }
    }
}
