//
//  NetworkAPI.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/27.
//

import Foundation

enum NetworkAPI {
    case market(MarketAPI)
}

extension NetworkAPI {
    var baseURL: String {
        return "http://152.67.217.201:8080"
    }
    
    var path: String {
        switch self {
        case .market(let api): return api.path
        }
    }
}

enum MarketAPI {
    case allMarkets
}

extension MarketAPI {
    var path: String {
        switch self {
        case .allMarkets:
            return "/market/all"
        }
    }
}
