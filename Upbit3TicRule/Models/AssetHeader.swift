//
//  AssetHeader.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit

public enum AssetHeader: Int, CaseIterable {
    case Coin, AvgBuyPrice, TotalPrice, Amount, ProfitOrLoss

}

extension AssetHeader {
    var text: String {
        switch self {
        case .Coin:
            return "코인명"
        case .AvgBuyPrice:
            return "매수 평균가"
        case .TotalPrice:
            return "매수 금액"
        case .Amount:
            return "평가 금액"
        case .ProfitOrLoss:
            return "평가 손익"
        }
    }
}
