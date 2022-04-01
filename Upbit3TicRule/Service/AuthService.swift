//
//  AuthService.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import Foundation
import UpbitSwift
import RealmSwift
import SwiftJWT

struct AuthService {
    static let shared = AuthService()
    var realm = try! Realm()
    
    func registerToken(withAccessKey accessKey: String, secretKey: String, completion: @escaping (()-> Void)) {
        
        let apiKey = realm.objects(ApiKey.self)
        
        // apiKey 모두 제거
        apiKey.forEach { (apikey) in
            try! realm.write {
                realm.delete(apikey)
            }
        }
        
        // apiKey 추가
        let newApiKey = ApiKey()
        newApiKey.accessKey = accessKey
        newApiKey.secretKey = secretKey
        try! realm.write {
            realm.create(ApiKey.self, value: newApiKey)
        }
        
        completion()
    }
    
    func getApiKey(with key: String) -> String {
        let apiKey = realm.objects(ApiKey.self).first
        if key == "access" {
            return apiKey?.accessKey ?? ""
        }
        if key == "secret" {
            return apiKey?.secretKey ?? ""
        }
        return ""
    }
}
