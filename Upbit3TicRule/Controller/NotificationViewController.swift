//
//  NotificationViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/10.
//

import UIKit
import SpreadsheetView
import RealmSwift

private let reuseIdentifier = "NotificationCell"

class NotificationViewController: UITableViewController  {
    
    // MARK: Properteis
    
    // 새로고침을 위한 Token
    var notificationToken: NotificationToken?
    
    private var notiList = NotiService.shared.getNotiList()
    
    private lazy var filterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y:0,width: self.view.frame.width, height: 70))
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        
        var filterImage = UIImageView(image: UIImage(named: "filter"))
        var filterLabel = UILabel()
        
        filterImage.setDimensions(width: 25, height: 25)
        filterLabel.textColor = UIColor(rgb: 0xAEAEB2)
        filterLabel.font = UIFont.boldSystemFont(ofSize: 18)
        filterLabel.text = "필터"
        stackView.addArrangedSubview(filterLabel)
        stackView.addArrangedSubview(filterImage)
        view.addSubview(stackView)
        stackView.centerY(inView: view)
        stackView.anchor(right: view.rightAnchor, paddingRight: 16)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedFilterView))
        stackView.addGestureRecognizer(tap)
        
        return view
    }()
    
    private var titleView: UILabel = {
        let label = UILabel()
        label.text = BottomTab.noti.title
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        navigationConfigure()
        tableConfigure()
        
        notificationToken = notiList.observe { [unowned self] changes in
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, _, _, _):
                // let users, let deletions, let insertions, let modifications
                self.tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    // MARK: Helper
    func navigationConfigure() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightSettingImageView)
    }
    
    func tableConfigure() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        //tableView.tableHeaderView = filterView
    }
    
    // MARK: Selector
    @objc func didTappedSettingImageView() {
        let controller = SettingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTappedFilterView() {
        let controller = FilterCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
}

// DataSource
extension NotificationViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! NotificationCell
        cell.backgroundColor = .systemGray5
        cell.noti = notiList[indexPath.row]
        return cell
    }
    
}
