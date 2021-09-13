//
//  NotificationTextField.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import UIKit

protocol NotificationPickerDelegate: AnyObject {
    func didSelectPick(data: String)
}

class NotificationTextField: UITextField {

    private var pickerList: [String]
    
    private var pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .systemBackground
        toolbar.tintColor = .riseColor
        toolbar.sizeToFit()
        return toolbar
    }()
    
    weak var pickerDelegate: NotificationPickerDelegate?
        
    init(frame: CGRect, pickerList: [String]) {
        self.pickerList = pickerList
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        pickerList = []
        super.init(coder: coder)
    }
    
    func configure() {
        self.inputView = pickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 15, weight: .medium)
        self.placeholder = "타입을 선택해 주세요"
        self.textColor = .basicColor
        self.clearButtonMode = .whileEditing
        configureToolbar()
    }
    
    private func configureToolbar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace,flexibleSpace,doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc private func donePicker(_ sender: UIBarButtonItem) {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.text = self.pickerList[row]
        pickerDelegate?.didSelectPick(data: pickerList[row])
        self.resignFirstResponder()
    }
    
}

extension NotificationTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = pickerList[row]
        pickerDelegate?.didSelectPick(data: pickerList[row])
    }
}
