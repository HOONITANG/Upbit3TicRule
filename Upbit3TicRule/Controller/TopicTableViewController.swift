//
//  TopicTableViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/24.
//

import UIKit
import Firebase


class TopicTableViewController: UITableViewController {
    
    //MARK: Properties
    
    // navigation Title View
    var titleView: UILabel = {
        let label = UILabel()
        label.text = "토픽 구독 테스트"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    
    var coins = NotiService.shared.getNoficiationCoinList()
    
    var topics = [Messaging.Topic]() {
        didSet {
            tableView.reloadData()
            headerLabel.text = "총 구독 카운트: \(topics.count) \n 총 코인 리스트: \(coins.count)"
        }
    }
    
    let headerView = UIView()
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigure()
        tableConfigure()
        getTopic()
    }
    
    //MARK: Helpers
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
    }
    
    func tableConfigure() {
        headerView.addSubview(headerLabel)
        headerView.setDimensions(width: 300, height: 80)
        headerLabel.center(inView: headerView)
        
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView
    }
    
    func getTopic() {
        Messaging.messaging().loadTopics { (topics, error) in
            DispatchQueue.main.async {
                self.topics = topics ?? []
            }
            
            topics?.forEach({ (topic) in
                print("Subscribed to topic: \(topic.name ?? "No name")")
            })
        }
    }
}

extension TopicTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = topics[indexPath.row].name
        return cell
    }
}
