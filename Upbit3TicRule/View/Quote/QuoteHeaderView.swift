//
//  MarketStatusView.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/11.
//

import UIKit

//protocol QuoteHeaderViewDelegate: class {
//    func didTappedRefreshImageView()
//}

class QuoteHeaderView: UIView {
    
    //MARK: Properties
    // var delegate: QuoteHeaderViewDelegate?
    
    var quoteStatus: QuoteStatus? {
        didSet {
            configureUI()
        }
    }
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.text = "업비트 BitCoin 3일 기준"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    lazy var screenBound = UIScreen.main.bounds
    lazy var width = screenBound.size.width - 32 - 5 // 382
    
    lazy var labelWidth1 = round(width * 0.10)
    lazy var labelWidth2 = round(width * 0.28)
    lazy var labelWidth3 = round(width * 0.22)
    lazy var labelWidth4 = round(width * 0.20)
    lazy var labelWidth5 = round(width * 0.20)
    
    private lazy var labelView1: UIView = {
        let view = createHeadLabel(title: "틱", width: labelWidth1, align: .left)
        return view
    }()
    
    private lazy var labelView2: UIView = {
        let view = createHeadLabel(title: "코인명", width: labelWidth2, align: .left)
        return view
    }()
    
    private lazy var labelView3: UIView = {
        let view = createHeadLabel(title: "기준가", width: labelWidth3, align: .right)
        return view
    }()
    
    private lazy var labelView4: UIView = {
        let view = createHeadLabel(title: "폭", width: labelWidth4, align: .right)
        return view
    }()
    
    private lazy var labelView5: UIView = {
        let view = createHeadLabel(title: "거래량", width: labelWidth5, align: .right)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        let topLineView = UIView()
        topLineView.backgroundColor = .lightGray
      
        let labelStackView = UIStackView(arrangedSubviews: [labelView1, labelView2, labelView3, labelView4, labelView5])
        let labelStackWrapperView = UIView()
        labelStackView.axis = .horizontal
        labelStackView.alignment = .leading
        labelStackView.distribution = .equalSpacing
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .clear
        addSubview(coinLabel)
        addSubview(topLineView)
        labelStackWrapperView.addSubview(labelStackView)
        addSubview(labelStackWrapperView)
        addSubview(bottomLineView)
        
        coinLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16,  paddingRight: 16)
        
        topLineView.anchor(top: coinLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingRight: 0, height: 1)
        
        labelStackView.anchor(top: labelStackWrapperView.topAnchor, left: labelStackWrapperView.leftAnchor, bottom: labelStackWrapperView.bottomAnchor, right: labelStackWrapperView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
        labelStackWrapperView.anchor(top: topLineView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        labelStackWrapperView.backgroundColor = UIColor(rgb: 0xECF0F8)
        
        bottomLineView.anchor(top: labelStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI() {
        guard let quoteStatus = quoteStatus else {
            return
        }
        var textColor: UIColor = .black
        switch quoteStatus {
        case .rise:
            textColor = .systemRed
        case .fall:
            textColor = .systemBlue
        case .even:
            textColor = .systemGray
        }
        
        let attributedTitle = NSMutableAttributedString(string: "업비트 BitCoin 3일 기준: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: quoteStatus.description, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: textColor]))
        
        coinLabel.attributedText = attributedTitle
    }
    
    //MARK: Selectors
//    @objc func didTappedRefreshImageView() {
//       // delegate?.didTappedRefreshImageView()
////        UIView.animate(withDuration: 0.5) {
////            let rotate = CGAffineTransform(rotationAngle: .pi)
////            self.refreshImageView.transform = rotate }
////            completion: { result in
////                let rotate = CGAffineTransform(rotationAngle: .zero)
////                self.refreshImageView.transform = rotate
////            } /// completion에서 iconView의 transform의 .zero로 하지 않으면 다시 눌러도 애니메이션이 실행되지 않음.
//    }
    
    //MARK: Helpers
    func createHeadLabel(title:String, imageName:String? = nil, width:CGFloat, align: NSTextAlignment) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = align
        
        let myString = NSMutableAttributedString(string: "\(title) ")
        // attribute
        if imageName != nil {
            let attachment = NSTextAttachment()
            // Set bound to reposition
            let imageOffsetY: CGFloat = -1.0
            attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 14, height: 14)
            attachment.image = UIImage(named: imageName!)
            let attachmentString = NSAttributedString(attachment: attachment)
            myString.append(attachmentString)
        }
        
        label.attributedText = myString
        
        // view 크기 조정
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0)
        
        return view
    }
    
}
