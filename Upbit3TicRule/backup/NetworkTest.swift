////
//
////  ViewController.swift
//
////  UpbitNetworkDemo
//
////
//
////  Created by Taehoon Kim on 2022/03/12.
//
////
//
//
//
//import UIKit
//
//import UpbitSwift
//
//
//
//class SampleViewController: UIViewController {
//
//    let upbitSwift = UpbitSwift()
//
//    var tickers = UpbitTickers()
//
//    var candles = UpbitCandles()
//
//
//
//
//
//    // 틱 시점을 잡고, 변동폭/3 의 3틱 이하로 내려 갔을 때 알림 울림
//
//    // 틱 시점을 올릴 때 그 가격을 저장을함. 그 가격에 변동폭/3  이상 오르면 틱을 초기화 하고, 틱 시점을 새로잡음.
//
//
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//
//
//        // 산시점의 tic
//
//        //
//
//        // 하락 장 -> 5%
//
//        //  5일 치 평균 금액 < 현재금액 -> 상승장
//
//
//
//
//
//        // 5분 변동폭
//
//        // 1500 / 3 -> 500
//
//        // 50 개씩 4번 끊어서 변동폭을 구함. [1, 2, 3, 4]
//
//        upbitSwift.getCandle(.minute(.five), market: "KRW-BTC", count: 200) { result in
//
//            switch result {
//
//            case .success(let candles):
//
//                guard let candles = candles else {
//
//                    return
//
//                }
//
//                // 나누는 point
//
//                // [(start: 0, end: 50), (start: 50, end: 100), (start: 100, end: 150), (start: 150, end: 200)]
//
//                let midpoint = candles.count / 2
//
//                let point:[(start:Int, end:Int)] = [
//                    (candles.startIndex, midpoint/2),
//                     (midpoint/2, midpoint),
//                     (midpoint, midpoint + (midpoint/2)),
//                     (midpoint + (midpoint/2), candles.endIndex)
//                ]
//                var diff: [ (value:Int, percent:Double, signed: Bool) ] = []
//                point.forEach { start, end in
//                    let candleMinMax: (min: UpbitCandle, max: UpbitCandle) = candles[start ..< end].reduce((candles[start],candles[start])) {
//                        let minCandle = $0.0.tradePrice < $1.tradePrice ? $0.0 : $1
//                        let maxCandle = $0.1.tradePrice > $1.tradePrice ? $0.1 : $1
//                        return ((minCandle), (maxCandle))
//                    }
//
//                    let signed = candleMinMax.min.timestamp < candleMinMax.max.timestamp
//                    let value = Int(candleMinMax.max.tradePrice) - Int(candleMinMax.min.tradePrice)
//                    var percent = Double(value) / Double(candleMinMax.max.tradePrice)
//                    percent = round(percent * 1000)
//                    percent = percent / 10
//
//                    diff.append((value: value, percent: percent, signed: signed))
//
//                }
//
//                print(diff)
//
//            case .failure(let error):
//                print(error.failureReason ?? "Not found error")
//            }
//        }
//
//        // 장세
//        upbitSwift.getCandle(.days, market: "KRW-BTC", count: 6) { result in
//
//            switch result {
//            case .success(let candles):
//                guard let candles = candles else {
//                    return
//                }
//
//                self.candles = candles
//                let tradeSum = Int(candles.reduce(0, {$0 + $1.tradePrice}))
//                let currentTradePrice = Int(candles.last?.tradePrice ?? 0)
//                let tradeAverage =  (tradeSum - currentTradePrice) / (candles.count - 1)
//
//                if tradeAverage < currentTradePrice {
//                    print("RISE")
//                } else if tradeAverage > currentTradePrice {
//                    print("FALL")
//                } else {
//                    print("EVEN")
//                }
//            case .failure(let error):
//                print(error.failureReason ?? "Not found error")
//            }
//        }
//
//        upbitSwift.getTickers(market: ["KRW-BTC"]) { result in
//            switch result {
//            case .success(let tickers):
//                self.tickers = tickers!
//            case .failure(let error):
//                print(error.failureReason ?? "Not found error")
//            }
//        }
//    }
//
//}
