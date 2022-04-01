//
//  FilterCollectionHeaderView.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/27.
//

import UIKit

protocol FilterCollectionHeaderDelegate {
    func allSelectButtonDidTapped(_ isAllSelect: Bool)
}

class FilterCollectionHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    
    var delegate: FilterCollectionHeaderDelegate?
    var headerData: (isAllSelect: Bool, inSearchMode: Bool)? {
        didSet {
            configureUI()
        }
    }
    
    lazy var allSelectButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 선택", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setDimensions(width: 80, height: 40)
        // button.contentHorizontalAlignment = .right
        //button.backgroundColor = UIColor(rgb: 0x7D7EFE)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(allSelectButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(allSelectButton)
        allSelectButton.centerY(inView: self)
        allSelectButton.anchor(right: rightAnchor, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selector
    @objc func allSelectButtonDidTapped() {
        guard let headerData = headerData else { return }
        let isAllSelect = headerData.isAllSelect
        delegate?.allSelectButtonDidTapped(isAllSelect)
        
        let newHeaderData = (!headerData.isAllSelect, headerData.inSearchMode)
        self.headerData = newHeaderData
    }
    
    // MARK: Helpers
    func configureUI() {
        guard let headerData = headerData else { return }
        let isAllSelect = headerData.isAllSelect
        let isSearchMode = headerData.inSearchMode
        
        allSelectButton.setTitle(isAllSelect ? "전체 해제" : "전체 선택", for: .normal)
        
        allSelectButton.isHidden = isSearchMode
    }
}
