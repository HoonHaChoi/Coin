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
        table.delaysContentTouches = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var requestNotifications: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNotificationCryptoButton
        configureUI()
        requestNotifications?()
    }
    
    private func configureUI() {
        view.addSubview(notificationsTableView)
        
        NSLayoutConstraint.activate([
            notificationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        notificationsTableView.registerClass(cell: NotificationCell.self)
        notificationsTableView.registerHeaderView(cell: NotificationHeaderView.self)
        notificationsTableView.dataSource = dataSource
        notificationsTableView.delegate = self
    }
    
    @objc func addNotification(){
        coordinator?.showSearchViewController(style: .notification)
    }
    
    lazy var updateNotification: ([Notifications]) -> () = { [weak self] notifiactions in
        self?.dataSource.updateDataSource(from: notifiactions)
        DispatchQueue.main.async {
            self?.notificationsTableView.reloadData()
        }
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { _, _, _  in
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { _, _, _ in
        }
        
        deleteAction.backgroundColor = .systemBackground
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.riseColor, renderingMode: .alwaysOriginal)
        
        editAction.backgroundColor = .systemBackground
        editAction.image = UIImage(systemName: "square.and.pencil")?.withTintColor(.fallColor, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
