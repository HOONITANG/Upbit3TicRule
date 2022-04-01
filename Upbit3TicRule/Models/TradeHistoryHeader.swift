//
//  TradeHistoryHeader.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/16.
//

import UIKit

public enum TradeHistoryHeader: Int, CaseIterable {
    case Coin, BuyPrice, SellPrice, ProfitPercent, ProfitPrice
}

extension TradeHistoryHeader {
    var text: String {
        switch self {
        case .Coin:
            return "코인명"
        case .BuyPrice:
            return "매수 금액"
        case .SellPrice:
            return "판매 금액"
        case .ProfitPercent:
            return "손익(%)"
        case .ProfitPrice:
            return "손익(KRW)"
        }
    }
}
