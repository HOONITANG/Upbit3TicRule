//
//  FilterCollectionViewCell.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/27.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    var coin: CoinNotification? {
        didSet {
            configureUI()
        }
    }
    
    lazy var wrapperView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        // let redColor: UIColor = .systemRed
        view.layer.borderColor = UIColor(rgb: 0x242C44).cgColor
        view.setDimensions(width: frame.width, height: frame.width)
        return view
    }()
    
    lazy var coinImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ATOM")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var coinLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet{
            wrapperView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.layer.cornerRadius = frame.width / 2
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        wrapperView.addSubview(coinImageView)
        coinImageView.anchor(top: wrapperView.topAnchor, left: wrapperView.leftAnchor, bottom: wrapperView.bottomAnchor, right: wrapperView.rightAnchor,paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
        
        addSubview(wrapperView)
        wrapperView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
//        wrapperView.backgroundColor = .red
//        
//        backgroundColor = .purple
//        coinLabel.backgroundColor = .yellow
        addSubview(coinLabel)
        coinLabel.anchor(top: wrapperView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        //wrapperView.layer.cornerRadius = 75 / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let coin = coin else {
            return
        }
        let coinText: String = coin.market.replacingOccurrences(of: "KRW-", with: "")
        coinLabel.text = coinText
        coinImageView.image = UIImage(named: coinText)
        
        // isSelected 값을 그냥 넣으면 터치가 안됨.
        // CollectionView에서 해줘야함.
        // isSelected = coin.isOn
    }
    
}
