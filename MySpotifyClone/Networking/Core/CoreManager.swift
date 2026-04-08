//
//  CoreManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation
import Alamofire

class CoreManager {
    func request<T:Codable>(model: T.Type,
                            method: String = "GET",
                            parameters: [String: Any]? = nil,
                            headers: [String: String]? = nil,
                            endpoint: String,
                            completion: @escaping((T?,String?) -> Void),
                            needAuth: Bool = false,
                            isRetry: Bool = false
    ) {
        guard let url = URL(string: endpoint) else  {
            completion(nil, "Yanlış URL")
            return
        }
        let httpMethod = HTTPMethod(rawValue: method)
        
        let encoding: ParameterEncoding = httpMethod == .get
        ? URLEncoding.default
        : URLEncoding.httpBody
        
        let afParameters: Parameters? = parameters
                
        let afHeaders: HTTPHeaders? = headers.map { dict in
            HTTPHeaders(dict.map { HTTPHeader(name: $0.key, value: $0.value) })
        }
        
        AF.request(url,
                   method: httpMethod,
                   parameters: afParameters,
                   encoding: encoding,
                   headers:afHeaders,).responseData { response in

            
            if response.response?.statusCode == 401,needAuth,!isRetry {
                AuthManager.shared.refreshAccessToken { [weak self] succes  in
                    guard succes else {
                        completion(nil,"Data gelmedi")
                        return
                    }
                    
                    guard let accessToken = KeychainManager.shared.accesToken else {
                        completion(nil, "Token yoxdur")
                        return
                    }
                    
                    
                    let newHeaders: [String: String] = [
                        "Authorization": "Bearer \(accessToken)"
                    ]
                    
                    self?.request(model: model,
                                 method: method,
                                 parameters: parameters,
                                 headers: newHeaders,
                                 endpoint: endpoint,
                                 completion: completion,
                                 needAuth: needAuth,
                                 isRetry: true)
                }
                return
            }
            
            
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(result,nil)
                    } catch {
    //                    print("DECODE XƏTA: \(error)")
                        completion(nil,error.localizedDescription)
                    }
                case .failure(let error):
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }


