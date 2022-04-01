////
////  Noti.swift
////  Upbit3TicRule
////
////  Created by Taehoon Kim on 2022/03/15.
////
//
//import Foundation
//
//public struct Noti: Codable {
//    public let market, koreanName, englishName, notificationStatus: String
//    public let notificationDateTimeUTC: String
//    public let notificationPrice: Double
//
//    enum CodingKeys: String, CodingKey {
//        case market
//        case koreanName = "korean_name"
//        case englishName = "english_name"
//        case notificationStatus = "notification_status"
//        case notificationDateTimeUTC = "notification_date_time_utc"
//        case notificationPrice = "notification_price"
//    }
//    
//    public init(data: Data) throws {
//        self = try JSONDecoder().decode(Noti.self, from: data)
//    }
//    
//    public init(market: String,
//                koreaName: String,
//                englishName: String,
//                notificationStatus: String,
//                notificationDateTimeUTC: String,
//                notificationPrice: Double) {
//        self.market = market
//        self.koreanName = koreaName
//        self.englishName = englishName
//        self.notificationStatus = notificationStatus
//        self.notificationDateTimeUTC = notificationDateTimeUTC
//        self.notificationPrice = notificationPrice
//    }
//}
//
//public typealias NotiList = [Noti]
//
//extension NotiList {
//    public init(data: Data) throws {
//        self = try JSONDecoder().decode(NotiList.self, from: data)
//    }
//}
