//
//  InputView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import UIKit

final class NotifiactionInputView: UIView {

    private let type: [String]
    private let cycle: [String]
    
    init(frame: CGRect,
         type: [String],
         cycle: [String]) {
        self.type = type
        self.cycle = cycle
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI() {
        addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scrollView.addSubview(typeLabel)
        scrollView.addSubview(typeSegmentControl)
        scrollView.addSubview(basePriceLabel)
        scrollView.addSubview(basePriceTextField)
        scrollView.addSubview(cycleLabel)
        scrollView.addSubview(cycleTextField)
        scrollView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            typeSegmentControl.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5),
            typeSegmentControl.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            typeSegmentControl.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            
            basePriceLabel.topAnchor.constraint(equalTo: typeSegmentControl.bottomAnchor, constant: 20),
            basePriceLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            basePriceLabel.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            
            basePriceTextField.topAnchor.constraint(equalTo: basePriceLabel.bottomAnchor, constant: 5),
            basePriceTextField.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            basePriceTextField.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            basePriceTextField.heightAnchor.constraint(equalToConstant: 45),
            
            cycleLabel.topAnchor.constraint(equalTo: basePriceTextField.bottomAnchor, constant: 20),
            cycleLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            cycleLabel.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            
            cycleTextField.topAnchor.constraint(equalTo: cycleLabel.bottomAnchor, constant: 5),
            cycleTextField.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            cycleTextField.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            cycleTextField.heightAnchor.constraint(equalTo: basePriceTextField.heightAnchor),
            
            completeButton.topAnchor.constraint(equalTo: cycleTextField.bottomAnchor, constant: 40),
            completeButton.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
            completeButton.heightAnchor.constraint(equalTo: basePriceTextField.heightAnchor)
            
        ])
        
        configureToolbar()
    }
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delaysContentTouches = false
        return scroll
    }()
    
    lazy var typeSegmentControl: UISegmentedControl = {
       let segment = UISegmentedControl(items: type)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    var basePriceTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "기준 가격을 입력해 주세요"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var cycleTextField: NotificationTextField = {
        let textField = NotificationTextField(frame: .zero,
                                              pickerList: cycle)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.configure()
        return textField
    }()
    
    var completeButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("알림 생성", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        if button.isEnabled {
            button.backgroundColor = .fallColor.withAlphaComponent(1.0)
        } else {
            button.backgroundColor = .fallColor.withAlphaComponent(0.3)
        }
        
        return button
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 타입"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .middleGrayColor
        return label
    }()
    
    private let basePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "기준 가격"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .middleGrayColor
        return label
    }()
    
    private let cycleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 주기"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .middleGrayColor
        return label
    }()
    
    private let toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .systemBackground
        toolbar.tintColor = .riseColor
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private func configureToolbar() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace,flexibleSpace,doneButton], animated: false)
        self.basePriceTextField.inputAccessoryView = toolBar
    }
    
    @objc private func donePicker(_ sender: UIBarButtonItem) {
        self.basePriceTextField.resignFirstResponder()
    }
}
