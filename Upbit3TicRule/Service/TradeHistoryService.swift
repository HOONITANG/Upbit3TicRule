//
//  TradeHistoryService.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/16.
//

import Foundation
import UpbitSwift
import RealmSwift

struct TradeHistoryService {
    static let shared = TradeHistoryService()
    var realm = try! Realm()
    
    
    func getTradeHistoryList() -> Data? {
        // 1. 불러올 파일 이름
        let fileNm: String = "tradeHistory"
        // 2. 불러올 파일의 확장자명
        let extensionType = "json"
        
        // 3. 파일 위치
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
        do {
            // 4. 해당 위치의 파일을 Data로 초기화하기
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            // 5. 잘못된 위치나 불가능한 파일 처리 (오늘은 따로 안하기)
            return nil
        }
    }
}
