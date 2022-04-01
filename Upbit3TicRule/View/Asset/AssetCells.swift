//
//  AssetCell.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit
import UpbitSwift
import SpreadsheetView

class AssetHeaderCell: Cell {
    // MARK: Properties
    var assetHeader: AssetHeader? {
        didSet {
            configureUI()
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let assetHeader = assetHeader else {
            return
        }
        label.text = assetHeader.text
    }
}


class AssetCell: Cell {
    // MARK: Properties
    var asset: (header: AssetHeader, data: Asset)? {
        didSet {
            configureUI()
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "label"
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return label
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        label.frame = bounds
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let asset = asset else {
            return
        }
        label.textColor = .black
       
        switch asset.header {
        case .Coin:
            label.text = asset.data.account.currency
        case .AvgBuyPrice:
            label.text = asset.data.avgBuyPrice.withCommas()
        case .TotalPrice:
            label.text = asset.data.totalprice.withCommas()
        case .Amount:
            label.text = asset.data.amount.withCommas()
        case .ProfitOrLoss:
            label.text = String(asset.data.profitOrLoss) + "%"
            label.textColor = asset.data.isProfit ? .systemRed : .systemBlue
        } 
    }
}

