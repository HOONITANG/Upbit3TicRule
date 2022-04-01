//
//  MainTabController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import UpbitSwift

class MainTabController: UITabBarController {
    // MARK: Properties
    
    private var quoteList = QuoteList() {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let quote = nav.viewControllers.first as? QuoteViewController else { return }
            quote.quoteList = quoteList
        }
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        fetchQuotes()
        configureViewController()
    }
    
    
    // MARK: Helpers
    func fetchQuotes() {
        QuoteService.shared.getQuoteList { (quoteList) in
            DispatchQueue.main.async {
                self.quoteList = quoteList
            }
        }
    }
    
    func configureViewController() {
        let quoteVC = QuoteViewController()
        let nav1 = templateNavigationController(.quote, rootViewController: quoteVC)
         
        let notiVC = NotificationViewController()
        let nav2 = templateNavigationController(.noti, rootViewController: notiVC)
        
        let assetVC = AssetViewController()
        let nav3 = templateNavigationController(.asset, rootViewController: assetVC)
        
//        let tradeHistoryVC = TradeHistoryViewController()
//        let nav4 = templateNavigationController(.tradeHistory, rootViewController: tradeHistoryVC)
        
        let authVC = AuthViewController()
        let nav4 = templateNavigationController(.auth, rootViewController: authVC)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(_ tabList: BottomTab, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = UIImage(named: tabList.image)
        tabBar.barTintColor = .white
        nav.tabBarItem.title = tabList.title
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
