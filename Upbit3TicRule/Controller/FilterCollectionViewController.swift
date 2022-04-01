//
//  FilterViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/25.
//

import UIKit

private let reuseIdentifier = "FilterCollectionViewCell"
private let headerIdentifier = "FilterCollectionHeaderView"
class FilterCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    
    // 코인 알람 리스트
    // market, isOn
    
    private var coinList = [CoinNotification]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var filterCoinList = [CoinNotification]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // 선택하거나, 선택해제한 코인들 인덱스
    var coinSelectedList = Set<CoinNotification>()
    
    // Navigation View
    var titleView: UILabel = {
        let label = UILabel()
        label.text = "알림설정"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "적용하기", style: .plain, target: self, action: #selector(handleRightNavTap))
        button.tintColor = .systemRed
        return button
    }()
    
    // Search View
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
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
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        getCoinList()
        navigationConfigure()
        searchControllerConfigure()
        collectionConfigure()
    }
    //MARK: Helpers
    func getCoinList() {
        coinList = NotiService.shared.getNoficiationCoinList()
            .toArray().map({ return CoinNotification(market: $0.market, isOn: $0.isOn)})
    }
    
    func navigationConfigure() {
        // navigationController?.navigationBar.tintColor = UIColor.white
        // navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x242C44)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        navigationItem.rightBarButtonItem = rightButton
    }
    func searchControllerConfigure() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색 할 코인을 입력하세요."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func collectionConfigure() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            // flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.allowsMultipleSelection = true
        
        // 선택 값 설정
        coinList.enumerated().forEach { (index, coin) in
            if coin.isOn == true {
                let selectedIndexPath = IndexPath(row: index, section: 0)
                collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
            }
        }
        collectionView.register(FilterCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    // MARK: Selector
    @objc func handleRightNavTap() {
        if coinSelectedList.count == 0 {
            self.dismiss(animated: true, completion: nil)
            return
        }
        LoadingIndicator.showLoading(with: self.progressView)
        NotiService.shared.marketSubscribe(by: Array(coinSelectedList)) { (completeCount) in
            DispatchQueue.main.async {
                self.progressView.setProgress( (Float(completeCount) / Float(self.coinSelectedList.count)), animated: false)
                
                if self.coinSelectedList.count - completeCount == 0 {
                    LoadingIndicator.hideLoading()
                    self.progressView.setProgress(0, animated: false)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
}

//MARK: - UISearchResultsUpdating
extension FilterCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filterCoinList = coinList.filter({return $0.market.lowercased().contains(searchText)})
        // filteredTodos = todosArray.filter({ return $0.title.lowercased().contains(searchText)})
    }
    
}

// MARK: - UICollectionViewDataSource
extension FilterCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filterCoinList.count : coinList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        
        let coin = inSearchMode ? filterCoinList[indexPath.row]: coinList[indexPath.row]
        cell.coin = coin
        
        if coin.isOn {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            cell.isSelected = true
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            cell.isSelected = false
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! FilterCollectionHeaderView
            header.delegate = self
            
            // header 전체선택, 전체 해제 필요.
            let selectCount = coinList.filter({ $0.isOn == true }).count
            let headerData = (isAllSelect: selectCount == coinList.count, inSearchMode: inSearchMode)
            header.headerData = headerData
            
            return header
            
        case UICollectionView.elementKindSectionFooter:
            return UIView() as! UICollectionReusableView
            
        default:
            assert(false, "Unexpected element kind")
            return UIView() as! UICollectionReusableView
        }
        
        
    }
}

//MARK: CollectionViewDelegate
extension FilterCollectionViewController {
    // CollectionView을 선택 했을 때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coin = inSearchMode ? filterCoinList[indexPath.row] : coinList[indexPath.row]
        
        coin.isOn = true
        coinSelectedList.insert(coin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let coin = inSearchMode ? filterCoinList[indexPath.row] : coinList[indexPath.row]
        
        coin.isOn = false
        coinSelectedList.insert(coin)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 5) - 20, height: 120)
    }
    // header Size, item과 header사이의 여백을 생각해서 높이를 지정해준다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
}

// MARK: - FilterCollectionHeaderDelegate
extension FilterCollectionViewController: FilterCollectionHeaderDelegate {
    func allSelectButtonDidTapped(_ isAllSelect: Bool) {
        // 전체 선택
        if !isAllSelect {
            coinList.enumerated().forEach { (index, coin) in
                // view 선택
                let selectedIndexPath = IndexPath(row: index, section: 0)
                collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
                // 저장될 coin목록
                coin.isOn = true
                coinSelectedList.insert(coin)
            }
        }
        // 전체 해제
        else {
            coinList.enumerated().forEach { (index, coin) in
                // view 선택 해제
                let selectedIndexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
                // 저장될 coin목록
                coin.isOn = false
                coinSelectedList.insert(coin)
            }
        }
    }
}
