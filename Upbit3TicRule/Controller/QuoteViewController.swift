//
//  ViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import UpbitSwift

private let reuseIdentifier = "QuoteCell"
class QuoteViewController: UITableViewController {
    // MARK: Properties
    var quoteList = QuoteList() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // navigation Title View
    var titleView: UILabel = {
        let label = UILabel()
        label.text = BottomTab.quote.title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var rightSettingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedSettingImageView))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let quoteHeaderView = QuoteHeaderView()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationConfigure()
        tableViewConfigure()
        fetchQuotes()
        getMarketTrend()
        initRefresh()
        
        //        view.addSubview(quoteStatusView)
        //        quoteStatusView.delegate = self
        //        quoteStatusView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor)
        //
        //        tableView.anchor(top: quoteStatusView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    // MARK: Helper
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSettingImageView)
    }
    
    func tableViewConfigure() {
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = quoteHeaderView
        tableView.register(QuoteCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.updateHeaderViewHeight()
    }
    
    func initRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
//        self.refreshControl?.backgroundColor = .yellow
//        self.refreshControl?.tintColor = .purple
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "새로고침")
    }
    
    // 시세를 호출하는 함수
    func fetchQuotes() {
        QuoteService.shared.getQuoteList { (quoteList) in
            DispatchQueue.main.async {
                self.quoteList = quoteList.sorted(by: { (first, second) -> Bool in
                    return first.tick > second.tick
                })
            }
        }
    }
    
    // 하락장,상승장을 계산하는 함수
    func getMarketTrend() {
        QuoteService.shared.getMarketTrend { (quoteStatus) in
            self.quoteHeaderView.quoteStatus = quoteStatus
        }
    }
    
    // MARK: Selector
    @objc func didTappedSettingImageView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        self.fetchQuotes()
        self.getMarketTrend()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl!.endRefreshing()
        }
    }
}

// DataSource
extension QuoteViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! QuoteCell
        cell.quote = quoteList[indexPath.row]
        return cell
    }
}

// Delegate
extension QuoteViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//extension QuoteViewController: QuoteHeaderViewDelegate {
//    func didTappedRefreshImageView() {
//        fetchQuotes()
//        getMarketTrend()
//    }
//}

