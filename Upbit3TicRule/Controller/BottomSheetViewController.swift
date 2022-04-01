//
//  BottomSheetViewController.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/17.
//
import UIKit
import RealmSwift

class BottomSheetViewController: UIViewController{
    
    // MARK: - Properties
    
    // 바텀 시트 높이
    let bottomHeight: CGFloat = 359
    let tableView = UITableView()
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private var coinList = NotiService.shared.getNoficiationCoinList() {
        didSet {
            tableView.reloadData()
        }
    }
    // Realm -> market - yn 연동 ㄱ                                                      
    
    // 기존 화면을 흐려지게 만들기 위한 뷰
    private let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    // 바텀 시트 뷰
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        return view
    }()
    
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        
        return view
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupUI()
        setupGestureRecognizer()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }

    // MARK: - @Functions
    private func setupTable() {
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(BottomSheetCell.self, forCellReuseIdentifier:  String(describing: BottomSheetCell.self))
    }
    
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)
        
        dimmedBackView.alpha = 0.0
        setupLayout()
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        dimmedBackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
       
        bottomSheetView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 20 )
        bottomSheetViewTopConstraint.isActive = true
        
        dismissIndicatorView.anchor(top: bottomSheetView.topAnchor, paddingTop: 12, width: 102, height: 7)
        dismissIndicatorView.centerX(inView: self.view)
        
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}

extension BottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BottomSheetCell.self)) as! BottomSheetCell
        cell.coin = coinList[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension BottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = coinList[indexPath.row]
        NotiService.shared.setNotificationCoin(isOn: !coin.isOn, market: coin.market)
        
        let cell = self.tableView.cellForRow(at: indexPath) as! BottomSheetCell
        cell.coin = CoinNotification(market: coin.market, isOn: !coin.isOn)
    }
}

extension BottomSheetViewController: BottomSheetDelegate {
    func switchStateDidChange(isOn: Bool, market: String) {
        
    }
}
