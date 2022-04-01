////
////  MainTabController.swift
////  Upbit3TicRule
////
////  Created by Taehoon Kim on 2022/03/10.
////
//
//import UIKit
//import UpbitSwift
//
//class MainTabController: UITabBarController {
//    // MARK: Properties
//    
//    private var quoteList = QuoteList() {
//        didSet {
//            guard let nav = viewControllers?[0] as? UINavigationController else { return }
//            guard let quote = nav.viewControllers.first as? QuoteViewController else { return }
//            quote.quoteList = quoteList
//        }
//    }
//    
//    private var marketList = UpbitMarketList() {
//        didSet {
//            let filtedData = marketList.filter({ $0.market.contains("KRW") })
//            marketList = filtedData
//        }
//    }
//    
//    // 현재가 정보
//    private var tickers = UpbitTickers() {
//        didSet {
//            var quoteList = QuoteList()
//            marketList.forEach { (item) in
//                guard let ticker = tickers.first(where: { $0.market == item.market }) else { return }
//                let quote = Quote(market: item, ticker: ticker)
//                quoteList.append(quote)
//            }
//            self.quoteList = quoteList
//        }
//    }
//    
//    private var markets = [String]()
//    
//    // MARK: LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        let upSwift = UpbitSwift()
//        
//        upSwift.getMarketAll(isDetails: false) { result in
//            switch result {
//            case .success(let marketList):
//                guard let marketList = marketList  else {
//                    return
//                }
//                self.marketList = marketList
//                self.markets = self.marketList.map({ $0.market })
//                
//                upSwift.getTickers(market: self.markets) { result in
//                    switch result {
//                    case .success(let tickers):
//                        guard let tickers = tickers  else {
//                            return
//                        }
//                        self.tickers = tickers
//                    case .failure(let error):
//                        print(error.failureReason ?? "Not found error")
//                    }
//                }
//                
//            case .failure(let error):
//                print(error.failureReason ?? "Not found error")
//            }
//        }
//        
//        configureViewController()
//    }
//    
//    // MARK: Helpers
//    func configureViewController() {
//        let quoteVC = QuoteViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let nav1 = templateNavigationController(.quote, rootViewController: quoteVC)
//        
//        let notiVC = NotificationViewController()
//        let nav2 = templateNavigationController(.noti, rootViewController: notiVC)
//        
//        let assetVC = AssetViewController()
//        let nav3 = templateNavigationController(.asset, rootViewController: assetVC)
//        
//        let tradeHistoryVC = TradeHistoryViewController()
//        let nav4 = templateNavigationController(.tradeHistory, rootViewController: tradeHistoryVC)
//        
//        let authVC = AuthViewController()
//        let nav5 = templateNavigationController(.auth, rootViewController: authVC)
//        
//        viewControllers = [nav1, nav2, nav3, nav4, nav5]
//    }
//    
//    func templateNavigationController(_ tabList: BottomTab, rootViewController: UIViewController) -> UINavigationController {
//        let nav = UINavigationController(rootViewController: rootViewController)
//        nav.tabBarItem.image = UIImage(named: tabList.image)
//        tabBar.barTintColor = .white
//        nav.tabBarItem.title = tabList.title
//        nav.navigationBar.barTintColor = .white
//        return nav
//    }
//}
