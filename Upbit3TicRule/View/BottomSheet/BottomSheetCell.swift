//
//  BottomSheetCell.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/17.
//

import UIKit

protocol BottomSheetDelegate: class {
    func switchStateDidChange(isOn: Bool, market: String)
}

class BottomSheetCell: UITableViewCell {
    
    var coin: CoinNotification? {
        didSet {
            configureUI()
        }
    }
    
    var delegate: BottomSheetDelegate?
    
    private let coinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "KRW-BTC"
        return label
    }()
    
    private lazy var toggleButton: UISwitch = {
        let switchButton = UISwitch()
        // switchButton.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        switchButton.setOn(false, animated: false)
        return switchButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [coinLabel, toggleButton])
        // contentView.isUserInteractionEnabled = true
        // contentView.addSubview(stackView)
        addSubview(stackView)
        stackView.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        stackView.centerY(inView: self)
       
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let coin = coin else {
            return
        }
        coinLabel.text = coin.market
        toggleButton.setOn(coin.isOn, animated: false)
    }
    
    // MARK: Selector
    @objc func switchStateDidChange(_ sender: UISwitch) {
        guard let coin = coin else {
            return
        }
        
        delegate?.switchStateDidChange(isOn: sender.isOn, market: coin.market)
    }
}
