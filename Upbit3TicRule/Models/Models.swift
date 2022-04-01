//
//  Models..swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/12.
//

import Foundation
import RealmSwift

class ApiKey: Object {
    @Persisted(primaryKey: true) var secretKey: String
    @Persisted var accessKey: String
}


// Upbit API를 통해 받아온 정보를 토대로,
// tick 횟수, 기준 변동폭을 저장하는 Object
class Trade: Object {
    @Persisted(primaryKey: true) var market: String        // 코인 String key
    @Persisted var tickCount: Int        // 하락 틱 횟수 (3번 이상 시 구매)
    @Persisted var countStandard: Int    // 변동폭 기준
    @Persisted var priceStandard: Int    // 가격 기준 값
    @Persisted var unit: Int             // 분 단위(유닛)
    @Persisted var candleDateTimeKst: String     // 캔들 기준 시각(KST 기준)
    @Persisted var candleDateTimeUTC: String    // 캔들 기준 시각(UTC 기준)
    
    convenience init(_ dictionary: [String: Any]) {
        self.init()
        
        self.market = dictionary["market"] as? String ?? ""
        self.tickCount = dictionary["tickCount"] as? Int ?? 0
        self.countStandard = dictionary["countStandard"] as? Int ?? 0
        self.priceStandard = dictionary["priceStandard"] as? Int ?? 0
        self.unit = dictionary["unit"] as? Int ?? 0
        self.candleDateTimeKst = dictionary["candleDateTimeKst"] as? String ?? ""
        self.candleDateTimeUTC = dictionary["candleDateTimeUTC"] as? String ?? ""
    }
}

class CoinNotification: Object {
    @Persisted(primaryKey: true) var market: String        // 코인 String key
    @Persisted var isOn: Bool = false
    
    convenience init(market: String,
                     isOn: Bool) {
        self.init()
        self.market = market
        self.isOn = isOn
    }
}

class Noti: Object {
    @Persisted var market: String
    @Persisted var koreanName: String
    @Persisted var englishName: String
    @Persisted var notificationStatus: String
    @Persisted var notificationDateTimeUTC: Date
    @Persisted var notificationPrice: String

    convenience init(market: String,
                koreaName: String,
                englishName: String,
                notificationStatus: String,
                notificationDateTimeUTC: String,
                notificationPrice: String) {
        self.init()
        self.market = market
        self.koreanName = koreaName
        self.englishName = englishName
        self.notificationStatus = notificationStatus
        
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: notificationDateTimeUTC)
        self.notificationDateTimeUTC = date ?? Date()
        self.notificationPrice = notificationPrice
    }
    
//    convenience init(userInfo: [AnyHashable : Any]) {
//            let market = userInfo["market"] as? String ?? ""
//           let koreaName = userInfo["korean_name"] as? String ?? ""
//           let englishName = userInfo["english_name"] as? String ?? ""
//           let notificationStatus = userInfo["notification_status"] as? String ?? ""
//           let notificationDateTimeUTC = userInfo["notification_date_time_utc"] as? String ?? ""
//           let notificationPrice = userInfo["notification_price"] as? String ?? "0"
//          
//        self.init(market: market,
//                  koreaName: koreaName,
//                  englishName: englishName,
//                  notificationStatus: notificationStatus,
//                  notificationDateTimeUTC: notificationDateTimeUTC,
//                  notificationPrice: Double(notificationPrice)!)
//    }
}


//let array = [Date(), Date(), Date(), Date()]
//
//let defaults = UserDefaults.standard
//defaults.set(array, forKey: "SavedDateArray")

//let defaults = UserDefaults.standard
//let array = defaults.array(forKey: "SavedDateArray")  as? [Date] ?? [Date]()
