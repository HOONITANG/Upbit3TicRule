//
//  NotiService.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import Foundation
import UpbitSwift
import RealmSwift
import FirebaseMessaging

struct NotiService {
    static let shared = NotiService()
    var realm = try! Realm()
    var upbitSwift = UpbitSwift()
    
    // 앱을 처음 실행 했을 때, 기본적으로 알림을 받는 코인
    // 기본적으로 알림을 받는 코인 설정. (KRW-BTC)
    func setDefaultNotificationCoin() -> Void {
        
        let coin = realm.object(ofType: CoinNotification.self, forPrimaryKey: "KRW-BTC")
        try! realm.write({
            coin?.isOn = true
        })
    }
    
    // 한 개의 코인 알람을 변경하고, 토픽도 변경해줌.
    func setNotificationCoin(isOn: Bool, market: String, completion: ((Error?) -> Void)? = nil ) {
        // Realm thread를 호출 할 때 마다 생성함.
        
        DispatchQueue.global(qos: .utility).async {
            autoreleasepool {
                let realm = try! Realm()
                let coin = realm.object(ofType: CoinNotification.self, forPrimaryKey: market)
                if coin != nil {
                    try! realm.write({
                        coin!.isOn = isOn
                    })
                    // Topic register
                    isOn ? subscribeTopic(by: market, completion: completion) : unSubscribeTopic(by: market, completion: completion)
                }
            }
        }
    }
    
    // coinList에 따른 코인 구독
    func marketSubscribe(by coinList:[CoinNotification], completion: @escaping (Int)->Void) {
        var completeCount = 0;
        coinList.forEach { (coin) in
            setNotificationCoin(isOn: coin.isOn, market: coin.market) { (error) in
                completeCount += 1
                completion(completeCount)
            }
        }
    }
    
    // 모든 코인 구독 및 체크
    func allMarketSubscribe(completion: @escaping (Int)->Void) {
        let coinList = getNoficiationCoinList()
        var completeCount = 0;
        
        coinList.forEach { (coin) in
            setNotificationCoin(isOn: true, market: coin.market) { (error) in
                completeCount += 1
                completion(completeCount)
            }
        }
    }
    
    // 모든 코인 구독해제 및 체크해제
    func allMarketUnSubscribe(completion: @escaping (Int)->Void) {
        let coinList = getNoficiationCoinList()
        var completeCount = 0;
        coinList.forEach { (coin) in
            setNotificationCoin(isOn: false, market: coin.market) { (error) in
                completeCount += 1
                completion(completeCount)
            }
        }
    }
    
    // 코인 알람들을 모두 가져옴
    func getNoficiationCoinList() -> Results<CoinNotification> {
        return realm.objects(CoinNotification.self)
    }
    // 업비트 시장에서 코인들을 가져와 설정을함.
    // 코인들을 가져와서 기존에 저장되지 않은 코인들만 추가함.
    func setNotificationCoinList() -> Void {
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        upbitSwift.getMarketAll(isDetails: false) { result in
            
            switch result {
            case .success(let marketList):
                guard let marketList = marketList  else {
                    return
                }
                
                let markets = marketList.map({ $0.market }).filter({ $0.contains("KRW")})
                
                markets.forEach { (market) in
                    let isExsist = realm.object(ofType: CoinNotification.self, forPrimaryKey: market)
                    if isExsist == nil {
                        let newNotification = CoinNotification()
                        newNotification.market = market
                        try! realm.write({
                            realm.create(CoinNotification.self, value: newNotification)
                        })
                    }
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
    // 전달 받은 Market 값으로 주제를 구독함
    
    func subscribeTopic(by market: String, completion: ((Error?) -> Void)? = nil) {
        Messaging.messaging().subscribe(toTopic: market, completion: completion)
    }
    
    func unSubscribeTopic(by market: String, completion: ((Error?) -> Void)? = nil) {
        Messaging.messaging().unsubscribe(fromTopic: market, completion: completion)
    }
    
    // 코인의 마켓 키 값으로 주제를 구독함.
    //    func setFcmTopics() {
    //        let coinList = getNoficiationCoinList()
    //        coinList.forEach { (coin) in
    //
    //            if Messaging.messaging().fcmToken != nil {
    //                if coin.isOn {
    //                    Messaging.messaging().subscribe(toTopic: coin.market)
    //                } else {
    //                    Messaging.messaging().unsubscribe(fromTopic: coin.market)
    //                }
    //            }
    //        }
    //    }
    
    // 알람 내역을 가져올 메서드
    func getNotiList() -> Results<Noti> {
        return realm.objects(Noti.self).sorted(byKeyPath: "notificationDateTimeUTC", ascending: false)
    }
    
    func setNoti(noti: Noti) {
        try! realm.write({
            realm.create(Noti.self, value: noti)
        })
    }
    //    func getNotiList() -> Data? {
    //        // 1. 불러올 파일 이름
    //        let fileNm: String = "notis"
    //        // 2. 불러올 파일의 확장자명
    //        let extensionType = "json"
    //
    //        // 3. 파일 위치
    //        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
    //        do {
    //            // 4. 해당 위치의 파일을 Data로 초기화하기
    //            let data = try Data(contentsOf: fileLocation)
    //            return data
    //        } catch {
    //            // 5. 잘못된 위치나 불가능한 파일 처리 (오늘은 따로 안하기)
    //            return nil
    //        }
    //    }
}
