//
//  TradeProfitView.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/16.
//

import UIKit

class TradeProfitView: UIView {
    
    //MARK: Properties
    let profitLabel: UILabel = {
        let label = UILabel()
        label.text = "손익"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let assetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "전체 재산"
        label.textColor = .black
        return label
    }()
    
    
    let profitValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-300000"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let assetValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-10.00"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profitContainerView = UIStackView(arrangedSubviews: [profitLabel, profitValueLabel])
        let assetContainerView = UIStackView(arrangedSubviews: [assetLabel, assetValueLabel])
     
        profitContainerView.axis = .vertical
        profitContainerView.spacing = 8
        profitContainerView.alignment = .leading
        
        assetContainerView.axis = .vertical
        assetContainerView.spacing = 8
        profitContainerView.alignment = .leading
        
        let tradeProfitContainerView = UIStackView(arrangedSubviews: [profitContainerView, assetContainerView])
        tradeProfitContainerView.axis = .horizontal
        tradeProfitContainerView.distribution = .fillEqually
        
        addSubview(tradeProfitContainerView)
        
        tradeProfitContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
    
    //MARK: Selector
    
}
