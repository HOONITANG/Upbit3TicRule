//
//  TabList.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import Foundation


public enum BottomTab {
    case quote, noti, asset, auth //tradeHistory
}

extension BottomTab {
    var image: String {
        switch self {
        case .quote:
            return "toggle_left_user_unselected"
        case .noti:
            return "bell_user_unselected"
        case .asset:
            return "briefcase_user_unselected"
//        case .tradeHistory:
//            return "pie_chart_user_unselected"
        case .auth:
            return "user_unselected"
        }
    }
    
    var title: String {
        switch self {
        case .quote:
            return "시세"
        case .noti:
            return "알림이력"
        case .asset:
            return "자산"
//        case .tradeHistory:
//            return "히스토리"
        case .auth:
            return "계정"
        }
    }
}
