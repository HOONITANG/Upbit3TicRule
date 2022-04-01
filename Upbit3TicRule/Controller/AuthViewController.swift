//
//  AuthViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import RealmSwift

class AuthViewController: UIViewController {
    // MARK: Properties
    private var titleView: UILabel = {
        let label = UILabel()
        label.text = BottomTab.auth.title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var tradeMarketContainerView: UIView = {
        let infoText = "코인 거래소"
        let view = Utilities().inputContainerView(withText: infoText, textField: tradeTextField, isWrite: false)
        return view
    }()
    
    private lazy var accessKeyContainerView: UIView = {
        let infoText = "Access Key"
        let view = Utilities().inputContainerView(withText: infoText, textField: accessTextField)
        return view
    }()
    
    private lazy var secretContainerView: UIView = {
        let infoText = "Secret Key"
        let view = Utilities().inputContainerView(withText: infoText, textField: secretTextField)
        return view
    }()
    
    private lazy var accessTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "API Access Key 입력")
        tf.text = AuthService.shared.getApiKey(with: "access")
        return tf
    }()
    
    private lazy var secretTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "API Secret Key 입력")
        tf.text = AuthService.shared.getApiKey(with: "secret")
        //tf.isSecureTextEntry = true
        return tf
    }()
    
    private let tradeTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "")
        tf.text = "업비트 (upbit)"
        return tf
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "거래소 사이트에서 발급 받은 API 키를 입력하세요.\n\nAPI키는 단말 내부에 암호화되어 저장되며, 서버로 전송하지 않습니다.\n\n보안을 위해 API 키 생성 시 거래 및 입출금 기능은 비활성화 하시기 바랍니다.(보유 자산 조회 기능만 활성화)"
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.backgroundColor = UIColor(rgb: 0x7D7EFE)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(didRegisterButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    private let tempTokenLabel: UILabel = {
//        let label = UILabel()
//        let text = UserDefaults.standard.string(forKey: "DeviceToken")
//        label.numberOfLines = 0
//        label.text = text
//        return label
//    }()
    
    lazy var rightSettingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedSettingImageView))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure()
        
        let stack = UIStackView(arrangedSubviews: [tradeMarketContainerView, accessKeyContainerView, secretContainerView, descriptionView, registerButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
    }

    // MARK: Helper
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSettingImageView)
    }
    
    // MARK: Selector
    @objc func didRegisterButtonTapped() {
        guard let accessKey = accessTextField.text else { return }
        guard let secretKey = secretTextField.text else { return }
        
        AuthService.shared.registerToken(withAccessKey: accessKey, secretKey: secretKey) {
            DispatchQueue.main.async {
                AlertHelper.showAlert(title: "등록 완료", message: "등록이 완료되었습니다.", over: self)
            }
        }
    }
    @objc func didTappedSettingImageView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

