//
//  QuoteHeader.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/11.
//

import UIKit

public enum QuoteHeader: Int, CaseIterable {
    case tick, coin, price, range, dayToday, volume
}

extension QuoteHeader {
    var text: String {
        switch self {
        case .tick:
            return "틱 "
        case .coin:
            return "코인명 "
        case .price:
            return "현재가 "
        case .range:
            return "폭 "
        case .dayToday:
            return "전일대비 "
        case .volume:
            return "거래량 "
        }
    }
    
    var image: UIImage? {
        let image = self == .tick ? UIImage(named: "bell_user_unselected") : UIImage(named: "align_filter")
        return image
    }
    
//    func getAttributeString() -> NSAttributedString {
//        let attributedString = NSMutableAttributedString(string: self.text)
//        let imageAttachment = NSTextAttachment()
//        let imageView = UIImageView(image: self == .tick ? UIImage(named: "bell_user_unselected") : UIImage(named: "align_filter"))
//        imageView.setDimensions(width: 16, height: 16)
//        
//        let image = self == .tick ? UIImage(named: "bell_user_unselected") : UIImage(named: "align_filter")
//        
//        
//        imageAttachment.image = image
//        attributedString.append(NSAttributedString(attachment: imageAttachment))
//
//        return attributedString
//    }
    
}
