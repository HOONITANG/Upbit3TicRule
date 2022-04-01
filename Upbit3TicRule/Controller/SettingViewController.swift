//
//  SettingViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/17.
//

import UIKit

class SettingViewController: UITableViewController {
    
    //MARK: Properties
    
    // coin 전체 리스트
    let coinList = NotiService.shared.getNoficiationCoinList()
    
    // 전체 구독, 전체 구독 해제를 위한 프로그레스바
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        view.progressTintColor = .systemBlue
        view.trackTintColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.sublayers![1].cornerRadius = 8// 뒤에 있는 회색 track
        view.subviews[1].clipsToBounds = true
        return view
    }()
    
    // navigation Title View
    var titleView: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigure()
        tableConfigure()
    }
    //MARK: Helpers
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
    }
    
    func tableConfigure() {
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        
       //tableView.tableFooterView = progressView
    }
}

extension SettingViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let setting = Setting(rawValue: indexPath.row) else {
            return cell
        }
        cell.textLabel?.text = setting.title
        
        return cell
    }
}

extension SettingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let setting = Setting(rawValue: indexPath.row) else {
            return
        }
        
        switch setting {
        case .notification:
            let controller = FilterCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
        case .removeAd:
            print("광고 제거 콜")
        case .restore:
            print("구매 내역 복원 콜")
        case .contactUs:
            openEmailApp(toEmail: "vinieo0000@gmail.com", subject: "문의하기", body: "문의할 내용을 작성해서 보내주세요.")
        case .license:
            print("라이선스 콜")
            
        case .topics:
            let controller = TopicTableViewController()
            self.navigationController?.pushViewController(controller, animated: true)
//        case .allMarketSubscribe:
//            LoadingIndicator.showLoading(with: self.progressView)
//            NotiService.shared.allMarketSubscribe { (completeCount) in
//                DispatchQueue.main.async {
//                    self.progressView.setProgress( (Float(completeCount) / Float(self.coinList.count)), animated: false)
//
//                    if self.coinList.count - completeCount == 0 {
//                        LoadingIndicator.hideLoading()
//                        self.progressView.setProgress(0, animated: false)
//                    }
//                }
//            }
//        case .allMarketUnSubscribe:
//            LoadingIndicator.showLoading(with: self.progressView)
//            NotiService.shared.allMarketUnSubscribe { (completeCount) in
//                DispatchQueue.main.async {
//                    self.progressView.setProgress( (Float(completeCount) / Float(self.coinList.count)), animated: false)
//                    if self.coinList.count - completeCount == 0 {
//                        LoadingIndicator.hideLoading()
//                        self.progressView.setProgress(0, animated: false)
//                    }
//                }
//            }
        }
    }
    
    func openEmailApp(toEmail: String, subject: String, body: String) {
        guard
            let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let body = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            print("Error: Can't encode subject or body.")
            return
        }
        
        let urlString = "mailto:\(toEmail)?subject=\(subject)&body=\(body)"
        let url = URL(string:urlString)!
        
        UIApplication.shared.open(url)
    }
    
    
}
