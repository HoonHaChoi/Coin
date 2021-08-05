//
//  TradingLogAddViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import UIKit

class TradingLogAddViewController: UIViewController, Storyboarded {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startAmountTextField: UITextField!
    @IBOutlet weak var endAmountTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!

    private lazy var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.locale = Locale(identifier: "ko_kr")
        picker.minimumDate = Calendar.current.date(byAdding: .year,
                                                   value: -10,
                                                   to: Date())
        picker.backgroundColor = .systemBackground
        return picker
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let cancellButton = UIBarButtonItem(title: "취소",
                                            style: .plain,
                                            target: nil,
                                            action: #selector(cancellBarButtonPressed))
        let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "확인",
                                         style: .done,
                                         target: nil,
                                         action: #selector(doneBarButtonPressed))
        toolbar.setItems([cancellButton,flexspace,doneButton], animated: true)
        cancellButton.tintColor = .systemRed
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.sizeToFit()
        return toolbar
    }()
    
    var dispatch: ((Action) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePickerTextField()
    }
    
    private func setDatePickerTextField() {
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc private func doneBarButtonPressed() {
        dispatch?(.dateInput(datePicker.date))
    }
    
    @objc private func cancellBarButtonPressed() {
        downkeyboard()
    }
    
    private func downkeyboard() {
        self.view.endEditing(true)
    }
    
    lazy var updateView: (ViewState) -> () = { [weak self] state in
        self?.downkeyboard()
        self?.dateTextField.text = state.selectDate
    }
}
