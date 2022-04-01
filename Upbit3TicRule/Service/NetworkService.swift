//
//  NetworkService.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/27.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func get(_ api: NetworkAPI,
             query paramter: [String: String]? = nil,
             completion: @escaping ((Data?, URLResponse?, Error?) -> Void)
    ) {
  
        print("URL is \(api.baseURL + api.path )")
        // request Header 설정
        var request = URLRequest(url: URL(string: api.baseURL + api.path)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 60.0
        
        // dataTask 요청
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}
