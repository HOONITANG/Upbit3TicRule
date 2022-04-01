//
//  QuoteList.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/11.
//

import Foundation

//"market":"KRW-1INCH",
//"candle_date_time_utc":"2022-03-26 15:10:00",
//"candle_date_time_kst":"2022-03-27 00:10:00",
//"standard_price":1935.0,
//"average_range":57.5,
//"standard_range":19.166666666666668,
//"tick":0,
//"unit":5

public struct Quote: Codable {
    //public let market, koreanName, englishName: String
    public let market: String //koreanName, englishName: String
    
    public let candleDateTimeUtc: String
    public let candleDateTimeKst: String
    public let standardPrice: Double

    public let averageRange: Double
    public let standardRagne: Double
    public let tick: Int
    public let unit: Int
    // public let tickCount: Int
    // public let tickVariancePrice, tickVariancePercent: Double
//    public let tradeVolume, signedChangeRate: Double
//    public let change: String
    enum CodingKeys: String, CodingKey {
        case market
//        case koreanName = "korean_name"
//        case englishName = "english_name"
        case candleDateTimeUtc = "candle_date_time_utc"
        case candleDateTimeKst = "candle_date_time_kst"
        case standardPrice = "standard_price"
        case averageRange = "average_range"
        case standardRagne = "standard_range"
        case tick
        case unit
 //        case tickCount = "tick_count"
//        case tickVariancePrice = "standard_range"
//        case tickVariancePercent = "tick_variance_percent"
//        case tradeVolume = "trade_volume"
//        case signedChangeRate = "signed_change_rate"
//        case change
        
    }
    
    public init(data: Data) throws {
        self = try JSONDecoder().decode(Quote.self, from: data)
    }
}

public typealias QuoteList = [Quote]

extension QuoteList {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(QuoteList.self, from: data)
    }
}

// 시장 장세

//public enum UpbitAPI {
//    case exchange(ExchangeAPI), quotation(QuotationAPI)
//}
//
//extension UpbitAPI {
//    var baseURL: String {
//        return "https://api.upbit.com/v1"
//    }
//
//    var path: String {
//        switch self {
//        case .exchange(let api): return api.path
//        case .quotation(let api): return api.path
//        }
//    }
//}


public enum QuoteStatus: CaseIterable {
    
    public static var allCases: [QuoteStatus] {
        return [.rise( QuoteLowHighStatus.nothing), .fall( QuoteLowHighStatus.nothing), .even( QuoteLowHighStatus.nothing)]
    }
    
    case rise(QuoteLowHighStatus),fall(QuoteLowHighStatus),even(QuoteLowHighStatus)
    
    var description: String {
        switch self {
        case .rise(let lowHighStatus):
            return "상승장" + lowHighStatus.description
        case .fall(let lowHighStatus):
            return "하락장 " + lowHighStatus.description
        case .even(let lowHighStatus):
            return "횡보장" + lowHighStatus.description
        }
    }
}

// 신고가 신저가
public enum QuoteLowHighStatus: String {
    case high,low,nothing
    
    var description: String {
        switch self {
        case .high:
            return "-신고가"
        case .low:
            return "-신저가"
        case .nothing:
            return ""
        }
    }
}



//    return firstArray = firstArray.map { item -> T in
//        guard let secondElm = secondArray.first(where: { $0.id == item.id }) else { return item }
//        var item = item
//        item.name = secondElm.name
//        return item
//    }
//
