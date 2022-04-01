////
////  QuoteHeaderView.swift
////  Upbit3TicRule
////
////  Created by Taehoon Kim on 2022/03/11.
////
//
//import UIKit
//import SpreadsheetView
//
//class QuoteHeaderCell: Cell {
//    // MARK: Properties
//    var quoteHeader: QuoteHeader? {
//        didSet {
//            configureUI()
//        }
//    }
//    
//    let label: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textColor = .black
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.setDimensions(width: 14, height: 14)
//        return iv
//    }()
//    
//    // MARK: LifeCycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        let stackView = UIStackView(arrangedSubviews: [label,imageView])
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.spacing = 4
//        stackView.distribution = .fillProportionally
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins  = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
//        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
//        contentView.addSubview(stackView)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    // MARK: Helpers
//    func configureUI() {
//        guard let quoteHeader = quoteHeader else {
//            return
//        }
//        label.text = quoteHeader.text
//        imageView.image = quoteHeader.image
//    }
//}
//
//
//class QuoteCell: Cell {
//    // MARK: Properties
//    var quote: (header: QuoteHeader, data: Quote)? {
//        didSet {
//            configureUI()
//        }
//    }
//    
//    let label: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .black
//        label.text = "label"
//        label.textAlignment = .center
//        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return label
//    }()
//    
//    let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.setDimensions(width: 14, height: 14)
//        return iv
//    }()
//    
//    // MARK: LifeCycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .white
//        label.frame = bounds
//        contentView.addSubview(label)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    // MARK: Helpers
//    func configureUI() {
//        guard let quote = quote else {
//            return
//        }
//        label.textColor = .black
//        
//        switch quote.header {
//        case .tick:
//            label.text = String(quote.data.tick)
//        case .coin:
//            label.text = quote.data.market
//        case .price:
////            if quote.data.change == "RISE" {
////                label.textColor = .red
////            } else if quote.data.change == "FALL" {
////                label.textColor = .blue
////            }
//            label.text = "\(quote.data.standardPrice)"
//        case .range:
//            label.text = "\(quote.data.standardRagne)"
//        case .dayToday:
//            // label.text = "\(quote.data.signedChangeRate)"
//            label.text = ""
//        case .volume:
//            //label.text = "\(quote.data.tradeVolume)"
//            label.text = ""
//        }
//    }
//}
//
