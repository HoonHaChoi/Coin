//
//  NotificationInputViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/09.
//

import UIKit

final class NotificationInputViewController: UIViewController {
    
    // 수정
    var typeMenu = ["상승": "up",
                "하락": "down"]
    
    var repectMenu = [
        "1분 간격으로 알림": "eb337599-8c4f-4dc8-8c95-9e6e84054259",
        "5분 간격으로 알림": "2d01f98e-ca62-4d10-a0bc-8880abadb2a3",
        "10분 간격으로 알림": "a1057597-4460-4f1a-b45d-4fd4248fadbb",
        "30분 간격으로 알림": "8b8bc4b7-15a5-422b-976c-69dc4a14b7b0",
        "1시간 간격으로 알림": "33b7553c-fbcc-48a5-b1be-291cfcc3f029"]
    
    init() {
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
    
    // 수정
    private lazy var notificationInputView: NotifiactionInputView = {
        let view = NotifiactionInputView(frame: .zero,
                             type: typeMenu.keys.map { String($0) },
                             cycle: repectMenu.keys.map { String($0) })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureConstraint()
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
        
    }
}
