//
//  QuoteCells.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/29.
//

import UIKit

class QuoteCell: UITableViewCell {
    // MARK: Properties
    var quote: Quote? {
        didSet {
            configureUI()
        }
    }
    lazy var screenBound = UIScreen.main.bounds
    lazy var width = screenBound.size.width - 32 - 5 // 382
    
    lazy var labelWidth1 = round(width * 0.10)
    lazy var labelWidth2 = round(width * 0.28)
    lazy var labelWidth3 = round(width * 0.22)
    lazy var labelWidth4 = round(width * 0.20)
    lazy var labelWidth5 = round(width * 0.20)
    
    private lazy var labelView1: UIView = {
        let view = createCellLabel(title: "틱", width: labelWidth1, align: .left)
        return view
    }()
    
    private lazy var labelView2: UIView = {
        let view = createCellLabel(title: "코인명", width: labelWidth2, align: .left)
        return view
    }()
    
    private lazy var labelView3: UIView = {
        let view = createCellLabel(title: "현재가", width: labelWidth3, align: .right)
        return view
    }()
    
    private lazy var labelView4: UIView = {
        let view = createCellLabel(title: "폭", width: labelWidth4, align: .right)
        return view
    }()
    
    private lazy var labelView5: UIView = {
        let view = createCellLabel(title: "거래량", width: labelWidth5, align: .right)
        return view
    }()
    
    //MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let labelStackView = UIStackView(arrangedSubviews: [labelView1, labelView2, labelView3, labelView4, labelView5])
        labelStackView.axis = .horizontal
        labelStackView.alignment = .leading
        labelStackView.distribution = .equalSpacing
        
        addSubview(labelStackView)
        
        labelStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let quote = quote else {
            return
        }
        
        let label1 = labelView1.subviews.first as! UILabel
        let label2 = labelView2.subviews.first as! UILabel
        let label3 = labelView3.subviews.first as! UILabel
        let label4 = labelView4.subviews.first as! UILabel
        let label5 = labelView5.subviews.first as! UILabel
        
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let standardPrice = numberFormatter.string(from: NSNumber(value:quote.standardPrice))!
        let standardRagne = numberFormatter.string(from: NSNumber(value:round(quote.standardRagne * 100) / 100))!
        
        label1.text = String(quote.tick)
        label2.text = quote.market
        label3.text = standardPrice
        label4.text = standardRagne //quote.signedChangeRate
        label5.text = "" //quote.tradeVolume
    }
    
    //MARK: Helpers
    func createCellLabel(title:String, width:CGFloat, align: NSTextAlignment ) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = align
      
        // view 크기 조정
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft:0, paddingBottom: 12, paddingRight: 0)
        
        return view
    }
}

