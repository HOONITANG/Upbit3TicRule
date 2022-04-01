//
//  NoHaveAuthView.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit

protocol NoHaveAuthViewDelegate: class {
    func didTappedAddButton()
}

class NoHaveAuthView: UIView {
    //MARK: Properties
    var delegate: NoHaveAuthViewDelegate?
        
    let descriptionlabel: UILabel = {
        let label = UILabel()
        label.text = "자산 정보를 추가 해주세요."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setDimensions(width: 120, height: 40)
        button.backgroundColor = UIColor(rgb: 0x7D7EFE)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTappedAddButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [descriptionlabel, addButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
    //MARK: Selectors
    @objc func didTappedAddButton() {
        delegate?.didTappedAddButton()
    }
    
}
