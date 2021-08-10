//
//  TradingLogAddViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import UIKit
import Combine

enum FormStyle {
    case add
    case edit(Date)
}

class TradingLogAddViewController: UIViewController, Storyboarded {

    private var viewForm: FormStyle
    
    init?(coder: NSCoder, style: FormStyle) {
        viewForm = style
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startAmountTextField: UITextField!
    @IBOutlet weak var endAmountTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    private lazy var datePickerToolBar: UIToolbar = {
        let toolbar = UIToolbar(width: view.frame.width,
                                leftAction: #selector(cancellBarButtonPressed),
                                rightAction: #selector(doneBarButtonPressed))
        return toolbar
    }()
    
    private lazy var cancellToolbar: UIToolbar = {
        let toolbar = UIToolbar(width: view.frame.width,
                                cancellAction: #selector(cancellBarButtonPressed))
        return toolbar
    }()
    private lazy var addBarButton: UIBarButtonItem = {
        let addBarButton = UIBarButtonItem(title: "등록", style: .done,
                                           target: self, action: #selector(addDoneButtonPressed))
        addBarButton.isEnabled = false
        return addBarButton
    }()
    
    var dispatch: ((Action) -> ())?
    private var cancellable = Set<AnyCancellable>()
    private let textViewPlaceHolderText = "메모(선택사항)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldToolbar()
        configureStartEndtextField()
        configureKeyboardNotification()
        configureNavigationAddItem()
        memoTextView.delegate = self
        setupTextView()
        switch viewForm {
        case .add:
            break
        case .edit(let date):
            dispatch?(.editInput(date))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = keyboardFrame.size.height * 0.8
        scrollView.contentInset.bottom = contentInset
        scrollView.verticalScrollIndicatorInsets =
            UIEdgeInsets(top: .zero, left: .zero, bottom: contentInset, right: .zero)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func configureNavigationAddItem() {
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addDoneButtonPressed() {
        dispatch?(.addTradingLog)
    }
    
    private func setTextFieldToolbar() {
        dateTextField.inputAccessoryView = datePickerToolBar
        dateTextField.inputView = datePicker
        
        startAmountTextField.inputAccessoryView = cancellToolbar
        endAmountTextField.inputAccessoryView = cancellToolbar
        memoTextView.inputAccessoryView = cancellToolbar
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
        self?.addBarButton.isEnabled = state.isFormValid
        
        if let alert = state.alert {
            self?.present(alert, animated: true) { [weak self] in
                self?.dispatch?(.alertDissmiss)
            }
        }
    }
}

extension TradingLogAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setupTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupTextView()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }
    
    private func setupTextView() {
        if memoTextView.text == textViewPlaceHolderText {
            memoTextView.text = nil
            memoTextView.textColor = .black
        } else if memoTextView.text.isEmpty {
            memoTextView.text = textViewPlaceHolderText
            memoTextView.textColor = .lightGray
        }
    }
}
