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
        return picker
    }()

    var dispatch: ((Action) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePickerTextField()
    }
    
    private func setDatePickerTextField() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
       
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBarButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc private func doneBarButtonPressed() {
        dispatch?(.dateInput(datePicker.date))
//        dateTextField.text = "\(datePicker.date)"
    }
    
    lazy var updateView: (ViewState) -> () = { [weak self] state in
        self?.dateTextField.text = state.selectDate
    }
}
