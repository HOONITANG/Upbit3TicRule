//
//  QuoteService.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/13.
//

import Foundation
import UpbitSwift
import RealmSwift

struct QuoteService {
    static let shared = QuoteService()
    let upbitSwift = UpbitSwift()
    var tickers = UpbitTickers()
    var candles = UpbitCandles()
    var realm = try! Realm()
    
    func getQuoteList(completion: @escaping (QuoteList) -> Void ) {
        
        NetworkService.shared.get(.market(.allMarkets)) { (data, response, error) in
            if let error = error {
                print("Error was an \(error.localizedDescription)")
            } else {
                // 성공시 수행
                guard let responseData = try? QuoteList(data: data!) else {
                    return
                }
                completion(responseData)
            }
        }
    }

    // 장세
    
    func getMarketTrend(completion: @escaping((QuoteStatus)->Void)) {
        upbitSwift.getCandle(.days, market: "KRW-BTC", count: 3) { result in
            switch result {
            case .success(let candles):
                guard let candles = candles else {
                    return
                }
//                let yesterDayPrice = candles[1].tradePrice
//                let tradeSum = Int(candles.reduce(0, {$0 + $1.tradePrice}))
                
                let todayPrice = candles.first?.tradePrice ?? 0
                let twoDaysAgoPrice = candles.last?.tradePrice ?? 0
                
                // 이틀전 가격 대비 얼마나 떨어지고, 올랐나 (변동폭 퍼센트)
                let range = round((Float(twoDaysAgoPrice - todayPrice) / Float(twoDaysAgoPrice)) * 10000) / 100
                
                let highestPrice = candles.reduce(0, { $0 < $1.tradePrice ? $1.tradePrice : $0 })
                let lowestPrice = candles.reduce(0, { $0 < $1.tradePrice ? $0 : $1.tradePrice })
                
                let isHighPrice = highestPrice == todayPrice
                let isLowPrice = lowestPrice == todayPrice
                let quoteLowHighStatus = isHighPrice ? QuoteLowHighStatus.high : (isLowPrice ? QuoteLowHighStatus.low : QuoteLowHighStatus.nothing)
                
                // 2일전과 비교하여 5%이내의 움직임일 경우 - 횡보장
                if range < 5 {
                    completion(QuoteStatus.even(quoteLowHighStatus))
                    return
                }
                
                // 2일전과 비교하여 상승 했을 경우 - 상승장
                if todayPrice - twoDaysAgoPrice > 0 {
                    completion(QuoteStatus.rise(quoteLowHighStatus))
                    return
                }
                
                // 2일전과 비교하여 하락 했을 경우 - 하락장
                else {
                    completion(QuoteStatus.fall(quoteLowHighStatus))
                    return
                }

            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
    // 변동폭 구하기
    func getCountStandard(market: String, complecation: @escaping ((Int) -> Void)) {
        upbitSwift.getCandle(.minute(.five), market: "KRW-BTC", count: 200) { result in
            switch result {
            case .success(let candles):
                guard let candles = candles else {
                    return
                }
                // 나누는 point
                // [(start: 0, end: 50), (start: 50, end: 100), (start: 100, end: 150), (start: 150, end: 200)]
                let midpoint = candles.count / 2

                let point:[(start:Int, end:Int)] = [
                    (candles.startIndex, midpoint/2),
                     (midpoint/2, midpoint),
                     (midpoint, midpoint + (midpoint/2)),
                     (midpoint + (midpoint/2), candles.endIndex)
                ]
                
                var diff: [ (value:Int, percent:Double, signed: Bool) ] = []
                
                point.forEach { start, end in
                    let candleMinMax: (min: UpbitCandle, max: UpbitCandle) = candles[start ..< end].reduce((candles[start],candles[start])) {
                        let minCandle = $0.0.tradePrice < $1.tradePrice ? $0.0 : $1
                        let maxCandle = $0.1.tradePrice > $1.tradePrice ? $0.1 : $1
                        return ((minCandle), (maxCandle))
                    }

                    let signed = candleMinMax.min.timestamp < candleMinMax.max.timestamp
                    let value = Int(candleMinMax.max.tradePrice) - Int(candleMinMax.min.tradePrice)
                    var percent = Double(value) / Double(candleMinMax.max.tradePrice)
                    percent = round(percent * 1000)
                    percent = percent / 10
                    diff.append((value: value, percent: percent, signed: signed))
                }
                
                let countStandard = diff.reduce(0){ $0 + $1.value} / diff.count
                complecation(Int(countStandard))
                
                guard let candle = candles.first else {
                    return
                }
                let trade = realm.object(ofType: Trade.self, forPrimaryKey: candle.market)
                if trade == nil {
                    let newTrade = Trade()
                    newTrade.market = candle.market
                    newTrade.tickCount = 0
                    newTrade.countStandard = countStandard
                    newTrade.priceStandard = Int(candle.tradePrice)
                    newTrade.unit = 5
                    newTrade.candleDateTimeKst = candle.candleDateTimeKst
                    newTrade.candleDateTimeUTC = candle.candleDateTimeUTC
                    try! realm.write {
                        realm.create(Trade.self, value: newTrade)
                    }
                } else {
                    try! realm.write {
                        trade?.tickCount = 0
                        trade?.countStandard = countStandard
                        trade?.priceStandard = Int(candle.tradePrice)
                        trade?.unit = 5
                        trade?.candleDateTimeKst = candle.candleDateTimeKst
                        trade?.candleDateTimeUTC = candle.candleDateTimeUTC
                   }
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
}
