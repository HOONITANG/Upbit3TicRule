//
//  Setting.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/17.
//

import Foundation

enum Setting: Int, CaseIterable {
    case notification
    case removeAd
    case restore
    case contactUs
    case license
    case topics
}

extension Setting {
    var title: String {
        switch self {
        case .notification:
            return "알림 설정"
        case .removeAd:
            return "광고 제거 구입"
        case .restore:
            return "구매내역 복원"
        case .contactUs:
            return "의견 보내기"
        case .license:
            return "라이센스"
        case .topics:
            return "주제 구독 리스트"
        }
        
    }
}
