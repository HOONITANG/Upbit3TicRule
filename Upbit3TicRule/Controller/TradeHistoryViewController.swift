//
//  TradeHistoryViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import SpreadsheetView

class TradeHistoryViewController: UIViewController {

    // MARK: Properties
    private var titleView: UILabel = {
        let label = UILabel()
        //label.text = BottomTab.tradeHistory.title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var tradeHistoryList = TradeHistoryList() {
        didSet {
            spreadsheetView.reloadData()
        }
    }
    
    // Date View
    let tradeDateFilterView = TradeDateFilterView()
    // Profit view
    let tradeProfitView = TradeProfitView()
    // Spread view
    private let spreadsheetView = SpreadsheetView()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure()
        spreadSheetConfigure()
        
        view.addSubview(tradeDateFilterView)
        tradeDateFilterView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        view.addSubview(tradeProfitView)
        tradeProfitView.anchor(top: tradeDateFilterView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(spreadsheetView)
        spreadsheetView.anchor(top: tradeProfitView.bottomAnchor, left:  view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        fetchHistoryList()
    }

    // MARK: Helper
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
    }
    
    func spreadSheetConfigure() {
        spreadsheetView.register(TradeHistoryHeaderCell.self, forCellWithReuseIdentifier: String(describing: TradeHistoryHeaderCell.self))
        
        spreadsheetView.register(TradeHistoryCell.self, forCellWithReuseIdentifier: String(describing: TradeHistoryCell.self))
        
        spreadsheetView.gridStyle = .none
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
    }
    
    func fetchHistoryList() {
        guard
            let jsonData =  TradeHistoryService.shared.getTradeHistoryList(), let tradeHistoryList = try? JSONDecoder().decode(TradeHistoryList.self, from: jsonData)
        else { return }
        self.tradeHistoryList = tradeHistoryList
       
    }
}

extension TradeHistoryViewController: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return TradeHistoryHeader.allCases.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + tradeHistoryList.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        guard let tradeHistoryHeader = TradeHistoryHeader(rawValue: column) else {
            return 0
        }
        
        switch tradeHistoryHeader {
        case .Coin:
            return 90
        case .BuyPrice:
            return 90
        case .SellPrice:
            return 90
        case .ProfitPercent:
            return 90
        case .ProfitPrice:
            return 90
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 55
    }
}

extension TradeHistoryViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        
        case (0..<TradeHistoryHeader.allCases.count, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TradeHistoryHeaderCell.self), for: indexPath) as! TradeHistoryHeaderCell
            // 해당 section에 맞는 타입을 불러옴
            guard let tradeHistoryHeader = TradeHistoryHeader(rawValue: indexPath.column) else {
                return cell
            }
            
            cell.tradeHistoryHeader = tradeHistoryHeader
            return cell
        case (0..<TradeHistoryHeader.allCases.count, 1...tradeHistoryList.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TradeHistoryCell.self), for: indexPath) as! TradeHistoryCell
            
            guard let tradeHistoryHeader = TradeHistoryHeader(rawValue: indexPath.column) else {
                return cell
            }
            let tradeHistory = tradeHistoryList[indexPath.row - 1]
            
            cell.tradeHistory = (tradeHistoryHeader, tradeHistory)
            cell.gridlines.bottom = .default
            
            return cell
        default:
            return nil
        }
    }
}
