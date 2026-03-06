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
                            completion: @escaping((T?,String?) -> Void)) {
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
                   headers:afHeaders,).validate().responseData { response in
            print("REQUEST HEADERS: \(response.request?.headers ?? [])")
               print("STATUS CODE: \(response.response?.statusCode ?? 0)")
            
            switch response.result {
            case .success(let data):
                print("RAW JSON: \(String(data: data, encoding: .utf8) ?? "")")
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result,nil)
                } catch {
                    print("DECODE XƏTA: \(error)")
                    completion(nil,error.localizedDescription)
                }
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
        }
    }
}

