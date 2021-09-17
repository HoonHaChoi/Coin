//
//  NotificationsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

final class NotificationsViewController: UIViewController {

    typealias NotificationDataSource = TableDataSource<NotificationCell, Notifications>
    
    private let dataSource: NotificationDataSource
    weak var coordinator: NotificationsCoordinator?
        
    init(dataSource: NotificationDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var addNotificationCryptoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotification))
        button.tintColor = .basicColor
        return button
    }()
    
    private let notificationsTableView: UITableView = {
        let table = UITableView()
        table.estimatedRowHeight = 70
        table.rowHeight = 70
        table.allowsSelection = false
        table.delaysContentTouches = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = .init()
        table.alpha = 0
        return table
    }()
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var requestNotifications: (() -> ())?
    var requestDeleteNotification: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNotificationCryptoButton
        configureUI()
        requestNotifications?()
    }
    
    private func configureUI() {
        view.addSubview(notificationsTableView)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            notificationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        notificationsTableView.registerClass(cell: NotificationCell.self)
        notificationsTableView.registerHeaderView(cell: NotificationHeaderView.self)
        notificationsTableView.dataSource = dataSource
        notificationsTableView.delegate = self
    }
    
    @objc func addNotification(){
        coordinator?.showSearchViewController(style: .notification)
    }
    
    lazy var updateNotifications: ([Notifications]) -> () = { [weak self] notifiactions in
        self?.dataSource.updateDataSource(from: notifiactions)
        DispatchQueue.main.async {
            self?.notificationsTableView.alpha = 1
            self?.notificationsTableView.reloadData()
        }
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "에러", message: error.description)
            self?.present(alert, animated: true)
        }
    }
    
    lazy var loadingHiddenState: ((Bool) -> ()) = { [weak self] state in
        DispatchQueue.main.async {
            self?.loadingView.isHidden = state
        }
    }
    
    lazy var completeMessage: ((String) -> ()) = { [weak self] message in
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message)
            self?.present(alert, animated: true)
        }
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = dataSource.model[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, complete  in
            let confirmAlert = UIAlertController().deleteNotifiationAlert() { _ in
                self?.requestDeleteNotification?(row.uuid)
                complete(true)
            }
            self?.present(confirmAlert, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, complete in
            let notiObject = NotificationObject(type: row.type,
                                                basePrice: Int(row.basePrice) ?? 0,
                                                tickerUUID: row.ticker.uuid,
                                                notificationCycleUUID: row.notificationCycle.uuid)
            self?.coordinator?.showNotificationInputViewController(from: notiObject)
            complete(true)
        }
        
        deleteAction.backgroundColor = .systemBackground
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.riseColor, renderingMode: .alwaysOriginal)
        
        editAction.backgroundColor = .systemBackground
        editAction.image = UIImage(systemName: "square.and.pencil")?.withTintColor(.fallColor, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
