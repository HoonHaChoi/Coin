//
//  TradingLogAddViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import UIKit
import Combine

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
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
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
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePickerTextField()
        configureStartEndtextField()
        memoTextView.delegate = self
        setupTextView()
    }
    
    private func setDatePickerTextField() {
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    private func configureStartEndtextField() {
        startAmountTextField.textPublisher.sink { [weak self] string in
            self?.dispatch?(.startAmountInput(string))
        }.store(in: &cancellable)
        
        endAmountTextField.textPublisher.sink { [weak self] string in
            self?.dispatch?(.endAmountInput(string))
        }.store(in: &cancellable)
        
        memoTextView.textPublisher.sink { [weak self] string in
            self?.dispatch?(.memoInput(string))
        }.store(in: &cancellable)
        
    }
    
    @objc private func doneBarButtonPressed() {
        dispatch?(.dateInput(datePicker.date))
        downkeyboard()
    }
    
    @objc private func cancellBarButtonPressed() {
        downkeyboard()
    }
    
    private func downkeyboard() {
        self.view.endEditing(true)
    }
    
    lazy var updateView: (ViewState) -> () = { [weak self] state in
        self?.dateTextField.text = state.selectDate
        self?.startAmountTextField.text = state.startAmount
        self?.endAmountTextField.text = state.endAmount
        self?.memoTextView.text = state.memo
    }
}

extension TradingLogAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setupTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setupTextView()
        }
    }
    
    private func setupTextView() {
        if memoTextView.text == "메모(선택사항)" {
            memoTextView.text = ""
            memoTextView.textColor = .black
        } else if memoTextView.text == "" {
            memoTextView.text = "메모(선택사항)"
            memoTextView.textColor = .lightGray
        }
    }
}
