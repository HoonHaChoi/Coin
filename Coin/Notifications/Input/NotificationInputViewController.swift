//
//  NotificationInputViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/09.
//

import UIKit
import Combine

enum NotificationInputFormStyle {
    case create
    case update
}

final class NotificationInputViewController: UIViewController {
    
    private let imageLoader: Loader
    private let notiObject: NotificationObject
    private let notifiactionTypeNames: [String]
    private let notificationCycleNames: [String]
    private let viewStyle: NotificationInputFormStyle
    
    init(notiObject: NotificationObject,
         imageLoader: Loader,
         type: [String],
         cycle: [String],
         formStyle : NotificationInputFormStyle) {
        self.notiObject = notiObject
        self.imageLoader = imageLoader
        self.notifiactionTypeNames = type
        self.notificationCycleNames = cycle
        self.viewStyle = formStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let infoView: DetailInfoView = {
        let view = DetailInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .DEDEDE
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var notificationInputView: NotifiactionInputView = {
        let view = NotifiactionInputView(frame: .zero,
                             type: notifiactionTypeNames,
                             cycle: notificationCycleNames)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cancellable = Set<AnyCancellable>()
    var basePriceHandler: ((String,NotificationInputType) -> ())?
    var cycleHandler: ((String, NotificationInputType) -> ())?
    var requestCoinHandler: ((String) -> ())?
    var requestCreateNotification: ((String, String) -> ())?
    var requestUpdateNotification: ((String, String) -> ())?
    var setUpdateConfigureHanlder: ((NotificationObject, NotificationInputFormStyle) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureConstraint()
        requestCoinHandler?(notiObject.tickerUUID ?? "")
        bind()
        setTitleButtonText()
        setUpdateConfigureHanlder?(notiObject,viewStyle)
    }

    private func configureConstraint() {
        view.addSubview(infoView)
        view.addSubview(seperator)
        view.addSubview(notificationInputView)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 55),
            
            seperator.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            seperator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            notificationInputView.topAnchor.constraint(equalTo: seperator.bottomAnchor),
            notificationInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        notificationInputView.configureUI()
        notificationInputView.buttonTappedHanlder = didCompleteButtonTapped
    }
    
    private func bind() {
        notificationInputView.basePriceTextField.textPublisher
            .sink { [weak self] price in
                self?.basePriceHandler?(price, .basePrice)
            }.store(in: &cancellable)
        
        notificationInputView.cycleTextField.pickerDelegate = self
    }
    
    private func setTitleButtonText() {
        let createTitle = "알림 생성"
        let updateTitle = "알림 수정"
        switch viewStyle {
        case .create:
            self.title = createTitle
            self.notificationInputView.completeButton.setTitle(createTitle, for: .normal)
        case .update:
            self.title = updateTitle
        self.notificationInputView.completeButton.setTitle(updateTitle, for: .normal)
        }
    }
    
    lazy var updateCompleteButtonState: (Bool) -> () = { [weak self] state in
        DispatchQueue.main.async {
            self?.notificationInputView.completeButton.isEnabled = state
        }
    }
    
    lazy var updateInfoView: (Coin) -> () = { [weak self] coin in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.infoView.configure(coin: coin, imageLoader: self.imageLoader)
        }
    }
    
    lazy var updateNotificationInputView: (Int, String, String) -> () = { [weak self] index, price, cycle in
        DispatchQueue.main.async {
            self?.notificationInputView.typeSegmentControl.selectedSegmentIndex = index
            self?.notificationInputView.basePriceTextField.text = price
            self?.notificationInputView.cycleTextField.text = cycle
        }
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        let alert = UIAlertController(title: "에러", message: error.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    lazy var didCompleteButtonTapped: (String) -> () = { [weak self] type in
        switch self?.viewStyle {
        case .create:
            self?.requestCreateNotification?(type, self?.notiObject.tickerUUID ?? "")
        case .update:
            self?.requestUpdateNotification?(type, self?.notiObject.notificationUUID ?? "" )
        case .none:
            break
        }
    }
    
    lazy var onDismiss = { [weak self] in
        DispatchQueue.main.async {
            let alert = UIAlertController(message: "성공적으로 등록되었습니다") { _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        self?.present(alert, animated: true)
        }
    }
    
    deinit {
        print(#function, "inputController")
    }
}

extension NotificationInputViewController: NotificationPickerDelegate {
    func didSelectPick(data: String) {
        cycleHandler?(data, .cycle)
    }
}
