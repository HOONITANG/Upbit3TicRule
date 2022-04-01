//
//  AssetViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import UpbitSwift
import SpreadsheetView

class AssetViewController: UIViewController {
    // MARK: Properties
    private var titleView: UILabel = {
        let label = UILabel()
        label.text = BottomTab.asset.title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let noHaveAuthView = NoHaveAuthView()
    private let spreadsheetView = SpreadsheetView()
    
    private var assetList = AssetList() {
        didSet {
            spreadsheetView.reloadData()
        }
    }
    
    private var accounts = UpbitAccounts()
    
    private var tickers = UpbitTickers() {
        didSet {
            var assetList = AssetList()
            accounts.forEach { (item) in
                if item.currency != "KRW" {
                    guard let ticker = tickers.first(where: { $0.market.contains(item.currency) }) else { return }
                    let asset = Asset(account: item, ticker: ticker)
                    assetList.append(asset)
                }
            }
            self.assetList = assetList
        }
    }
    
    lazy var rightSettingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedSettingImageView))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    //timer 1초마다 cell의 시간을 업데이트 시킨다.
    lazy var timer = TimerHelper { (seconds) in
        self.fetchAssetData()
    }
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let secretKey = AuthService.shared.getApiKey(with: "secret")
        let accessKey = AuthService.shared.getApiKey(with: "access")
        let upbitSwift = UpbitSwift(accessKey: accessKey, secretKey: secretKey)

        upbitSwift.getAccounts() { result in
            switch result {
            case .success(let accounts):
                guard let _ = accounts else {
                    // 자산 추가 보여줌.(auth 실패)
                    DispatchQueue.main.async {
                        self.noHaveAuthView.isHidden = false
                        self.spreadsheetView.isHidden = true
                    }
                    return
                }
                DispatchQueue.main.async {
                    //auth 성공
                    self.noHaveAuthView.isHidden = true
                    self.spreadsheetView.isHidden = false
                }
                
               
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure()
        spreadSheetConfigure()
        fetchAssetData()
        
        noHaveAuthView.delegate = self
        view.addSubview(noHaveAuthView)
        noHaveAuthView.centerX(inView: self.view, topAnchor: self.view.topAnchor, paddingTop: (view.frame.height / 2) - 150)
        view.addSubview(spreadsheetView)
        spreadsheetView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        
        timer.start()
    }
    
    // MARK: Helper
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSettingImageView)
    }
    
    func spreadSheetConfigure() {
        spreadsheetView.register(AssetHeaderCell.self, forCellWithReuseIdentifier: String(describing: AssetHeaderCell.self))
        
        spreadsheetView.register(AssetCell.self, forCellWithReuseIdentifier: String(describing: AssetCell.self))
        
        spreadsheetView.gridStyle = .none
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
    }
    
    func fetchAssetData() {
        let secretKey = AuthService.shared.getApiKey(with: "secret")
        let accessKey = AuthService.shared.getApiKey(with: "access")
        let upbitSwift = UpbitSwift(accessKey: accessKey, secretKey: secretKey)
        
        upbitSwift.getAccounts() { [self] result in
            switch result {
            case .success(let accounts):
                guard let accounts = accounts else {
                    return
                }
                self.accounts = accounts
                let markets = accounts
                    .filter({ $0.currency != "KRW"})
                    .map({ "KRW" + "-" +  $0.currency })
                
                upbitSwift.getTickers(market: markets) { result in
                    switch result {
                    case .success(let tickers):
                        guard let tickers = tickers  else {
                            return
                        }
                        self.tickers = tickers
                    case .failure(let error):
                        print(error.failureReason ?? "Not found error")
                    }
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
    // MARK: Selector
    @objc func didTappedSettingImageView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AssetViewController: NoHaveAuthViewDelegate {
    func didTappedAddButton() {
        self.tabBarController?.selectedIndex = 3
    }
}

extension AssetViewController: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return AssetHeader.allCases.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + assetList.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        guard let assetHeader = AssetHeader(rawValue: column) else {
            return 0
        }
        
        switch assetHeader {
        case .Coin:
            return 80
        case .AvgBuyPrice:
            return 90
        case .TotalPrice:
            return 90
        case .Amount:
            return 90
        case .ProfitOrLoss:
            return 90
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 55
    }
}

extension AssetViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        
        case (0..<AssetHeader.allCases.count, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: AssetHeaderCell.self), for: indexPath) as! AssetHeaderCell
            // 해당 section에 맞는 타입을 불러옴
            guard let assetHeader = AssetHeader(rawValue: indexPath.column) else {
                return cell
            }
            
            cell.assetHeader = assetHeader
            return cell
        case (0..<AssetHeader.allCases.count, 1...assetList.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: AssetCell.self), for: indexPath) as! AssetCell
            
            guard let assetHeader = AssetHeader(rawValue: indexPath.column) else {
                return cell
            }
            let asset = assetList[indexPath.row - 1]
            
            cell.asset = (assetHeader, asset)
            cell.gridlines.bottom = .default
            
            return cell
        default:
            return nil
        }
    }
}

