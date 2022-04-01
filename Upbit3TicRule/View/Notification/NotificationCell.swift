//
//  Notificationcell.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit

class NotificationCell: UITableViewCell {
    // MARK: Properties
    var noti: Noti? {
        didSet {
            configureUI()
        }
    }
    
    private let marketLabel: UILabel = {
        let label = UILabel()
        label.text = "KRW-BTC"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "50000000 KRW"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let notiStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "매수 알림"
        label.textColor = .red
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "22.03.30 03:12"
        label.textColor = .black
        return label
    }()
    
    // MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let leftStackView = UIStackView(arrangedSubviews: [notiStatusLabel, dateLabel])
        leftStackView.axis = .vertical
        leftStackView.spacing = 6
        leftStackView.alignment = .trailing
        
        let totalStackView = UIStackView(arrangedSubviews: [marketLabel, priceLabel, leftStackView])
        totalStackView.axis = .horizontal
        totalStackView.distribution = .equalSpacing
        
        addSubview(totalStackView)
        totalStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let noti = noti else {
            return
        }
        marketLabel.text = noti.market
        priceLabel.text = noti.notificationPrice + "KRW"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: noti.notificationDateTimeUTC)
        
        dateLabel.text = dateString
        if noti.notificationStatus == "buy" {
            notiStatusLabel.text = "매수 알림"
            notiStatusLabel.textColor = .systemRed
        } else {
            notiStatusLabel.text = "매도 알림"
            notiStatusLabel.textColor = .systemBlue
        }
    }
    
    // 시간에 대한 attributeText
    fileprivate func attributeText(text: String, with: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(text) ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "\(with)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
}
