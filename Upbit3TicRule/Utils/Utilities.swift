//
//  Utilities.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit

class Utilities {
    func inputContainerView(withText text: String, textField: UITextField, isWrite: Bool = true) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        label.text = text
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.addSubview(label)
        
        label.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8)
        textField.textAlignment = .left
        
        if !isWrite {
            view.layer.cornerRadius = 8
            textField.backgroundColor = .systemGray5
            textField.isUserInteractionEnabled = false
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 16)

        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return tf
    }
}
