//
//  TradeDateFilterView.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/15.
//

import UIKit
import DatePickerDialog

public enum TradeDateFilter: String, CaseIterable {
    case One,Month,ThreeMonth,Pick
    
    var text: String {
        switch self {
        case .One:
            return "하루"
        case .Month:
            return "1개월"
        case .ThreeMonth:
            return "3개월"
        case .Pick:
            return "날짜지정"
        }
    }
}

protocol TradeDateFilterViewDelegate:class {
    func didTappedTextField(textField: UITextField)
}

class TradeDateFilterView: UIView {
    
    //MARK: Properties
    var delegate: TradeDateFilterViewDelegate?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    private var dateButtonViews:[UIView] = [UIView]()
    private let currentDate = Date()
    private let startDateTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        return tf
    }()
    
    private let endDateTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        return tf
    }()
    
    private lazy var startDateTextFieldContainer: UIView = {
        let view = UIView()
        
        view.addSubview(startDateTextField)
        startDateTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8)
        view.backgroundColor = .systemGray5
        startDateTextField.delegate = self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        startDateTextField.text = formatter.string(from: currentDate)
        return view
    }()
    
    private lazy var endDateTextFieldContainer: UIView = {
        let view = UIView()
        
        view.addSubview(endDateTextField)
        endDateTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8)
        view.backgroundColor = .systemGray5
        endDateTextField.delegate = self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        endDateTextField.text = formatter.string(from: currentDate)
        return view
    }()
    
    private let tildeLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        return label
    }()
    
    private lazy var dateTextFieldView: UIView = {
        let view = UIView()
        view.addSubview(startDateTextFieldContainer)
        view.addSubview(tildeLabel)
        view.addSubview(endDateTextFieldContainer)
        
        tildeLabel.center(inView: view)
        startDateTextFieldContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: tildeLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8)
        startDateTextFieldContainer.layer.cornerRadius = 8
        
        endDateTextFieldContainer.anchor(top: view.topAnchor, left: tildeLabel.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
        endDateTextFieldContainer.layer.cornerRadius = 8
        tildeLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        return view
    }()
    
    let datePicker = DatePickerDialog(locale: Locale(identifier: "ko-KR"))
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        TradeDateFilter.allCases.enumerated().forEach { (index, tradeDate) in
            let view = UIView()
            let button = DateButton()
            button.tradeDate = tradeDate
            view.backgroundColor = UIColor(rgb: 0x242C44)
            view.layer.cornerRadius = 10
            
            button.setTitle(tradeDate.text, for: .normal)
            button.addTarget(self, action: #selector(didTappedDateButton(_:)), for: .touchUpInside)
            view.addSubview(button)
            button.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
            
            dateButtonViews.append(view)
        }
        
        let dateButtonStack = UIStackView(arrangedSubviews: dateButtonViews)
        dateButtonStack.axis = .horizontal
        dateButtonStack.spacing = 12
        
        let dateLabelStack = UIStackView(arrangedSubviews: [dateLabel, dateButtonStack])
        dateLabelStack.axis = .horizontal
        dateLabelStack.distribution = .equalSpacing
        
        let dateStackView = UIStackView(arrangedSubviews: [dateLabelStack, dateTextFieldView])
        dateStackView.axis = .vertical
        dateStackView.spacing = 12
        addSubview(dateStackView)
        
        dateStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func datePickerTapped(textField: UITextField) {
        let currentDate = Date()
//        var dateComponents = DateComponents()
//        dateComponents.month = -26
//        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
//
        datePicker.show("날짜 선택",
                        doneButtonTitle: "완료",
                        cancelButtonTitle: "취소",
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                textField.text = formatter.string(from: dt)
                self.delegate?.didTappedTextField(textField: textField)
            }
        }
    }
    
    //MARK: Selector
    @objc func didTappedDateButton(_ sender: DateButton) {
        switch sender.tradeDate! {
        case .One:
            print("one")
        case .Month:
            print("month")
        case .ThreeMonth:
            print("3month")
        case .Pick:
            print("pick")
        }
    }
}

class DateButton: UIButton {
    var tradeDate: TradeDateFilter?
}

extension TradeDateFilterView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.endDateTextField {
            datePickerTapped(textField: textField)
            return false
        }
        
        if textField == self.startDateTextField {
            datePickerTapped(textField: textField)
            return false
        }
        
        return true
    }
}
