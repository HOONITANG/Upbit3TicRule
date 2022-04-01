////
////  ViewController.swift
////  Upbit3TicRule
////
////  Created by Taehoon Kim on 2022/03/10.
////
//
//import UIKit
//import UpbitSwift
//import SpreadsheetView
//
//class QuoteViewController: UIViewController {
//    // MARK: Properties
//    var quoteList = QuoteList() {
//        didSet {
//            spreadsheetView.reloadData()
//        }
//    }
//    // navigation Title View
//    var titleView: UILabel = {
//        let label = UILabel()
//        label.text = BottomTab.quote.title
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }()
//    
//    lazy var rightSettingImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "settings")
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedSettingImageView))
//        iv.addGestureRecognizer(tap)
//        return iv
//    }()
//    
//    //timer 1초마다 cell의 시간을 업데이트 시킨다.
//    let timer = TimerHelper { (seconds) in
//        QuoteService.shared.getCountStandard(market: "KRW-BTC") { (countStandard) in
//            print(countStandard)
//        }
//    }
//    
//    private let quoteStatusView = QuoteStatusView()
//    private let spreadsheetView = SpreadsheetView()
//    
//    // MARK: LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        navigationConfigure()
//        spreadSheetConfigure()
//        fetchQuotes()
//        getMarketTrend()
//        
//        view.addSubview(quoteStatusView)
//        quoteStatusView.delegate = self
//        quoteStatusView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor)
//        
//        view.addSubview(spreadsheetView)
//        spreadsheetView.anchor(top: quoteStatusView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
//    }
//    
//    // MARK: Helper
//    func navigationConfigure() {
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
//        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.titleView = titleView
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSettingImageView)
//    }
//    
//    func spreadSheetConfigure() {
//        spreadsheetView.register(QuoteHeaderCell.self, forCellWithReuseIdentifier: String(describing: QuoteHeaderCell.self))
//        
//        spreadsheetView.register(QuoteCell.self, forCellWithReuseIdentifier: String(describing: QuoteCell.self))
//        
//        // spreadsheetView.gridStyle = .solid(width: 1, color: .link)
//        spreadsheetView.gridStyle = .none
//        spreadsheetView.dataSource = self
//        spreadsheetView.delegate = self
//    }
//    
//    // 시세를 호출하는 함수
//    func fetchQuotes() {
//        QuoteService.shared.getQuoteList { (quoteList) in
//            DispatchQueue.main.async {
//                self.quoteList = quoteList.sorted(by: { (first, second) -> Bool in
//                    return first.tick > second.tick
//                })
//            }
//        }
//    }
//    
//    // 하락장,상승장을 계산하는 함수
//    func getMarketTrend() {
//        QuoteService.shared.getMarketTrend { (quoteStatus) in
//            self.quoteStatusView.quoteStatus = quoteStatus
//        }
//    }
//    
//    // MARK: Selector
//    @objc func didTappedSettingImageView() {
//        let controller = SettingViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
//}
//
//
//extension QuoteViewController: SpreadsheetViewDataSource {
//    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
//        return QuoteHeader.allCases.count
//    }
//    
//    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
//        return 1 + quoteList.count
//    }
//    
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
//        
//        guard let quoteHeader = QuoteHeader(rawValue: column) else {
//            return 0
//        }
//        
//        switch quoteHeader {
//        case .tick:
//            return 50
//        case .coin:
//            return 90
//        case .price:
//            return 90
//        case .range:
//            return 90
//        case .dayToday:
//            return 90
//        case .volume:
//            return 90
//        }
//    }
//    
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
//        return 55
//    }
//}
//
//extension QuoteViewController: SpreadsheetViewDelegate {
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
//        switch (indexPath.column, indexPath.row) {
//       
//        case (0..<QuoteHeader.allCases.count, 0):
//            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: QuoteHeaderCell.self), for: indexPath) as! QuoteHeaderCell
//            // 해당 section에 맞는 타입을 불러옴
//            guard let quoteHeader = QuoteHeader(rawValue: indexPath.column) else {
//                return cell
//            }
//            
//            cell.quoteHeader = quoteHeader
//            return cell
//        case (0..<QuoteHeader.allCases.count, 1...quoteList.count):
//            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: QuoteCell.self), for: indexPath) as! QuoteCell
//            
//            guard let quoteHeader = QuoteHeader(rawValue: indexPath.column) else {
//                return cell
//            }
//            let quote = quoteList[indexPath.row - 1]
//           
//            cell.quote = (quoteHeader, quote)
//            cell.gridlines.bottom = .default
//            //print(test)
//            
//            return cell
//        default:
//            return nil
//        }
//    }
//}
//
//extension QuoteViewController: QuoteStatusDelegate {
//    func didTappedRefreshImageView() {
//        fetchQuotes()
//        getMarketTrend()
//    }
//}
