//
//  TradeHistory.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/16.
//

import Foundation

public struct TradeHistory: Codable {
    let market: String
    let buyPrice, sellPrice: Int
    let profitPercent: String
    let profitPrice: Int

    enum CodingKeys: String, CodingKey {
        case market
        case buyPrice = "buy_price"
        case sellPrice = "sell_price"
        case profitPercent = "profit_percent"
        case profitPrice = "profit_price"
    }

    public init(data: Data) throws {
        self = try JSONDecoder().decode(TradeHistory.self, from: data)
    }
}

public typealias TradeHistoryList = [TradeHistory]

extension TradeHistoryList {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(TradeHistoryList.self, from: data)
    }
}
