//
//  NotificationsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

class NotificationsViewController: UIViewController {

    weak var coordinator: NotificationsCoordinator?
    
    private lazy var addNotificationCryptoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotification))
        button.tintColor = .basicColor
        return button
    }()
    
    private let notificationsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNotificationCryptoButton
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(notificationsTableView)
        
        NSLayoutConstraint.activate([
            notificationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        notificationsTableView.register(cell: NotificationCell.self)
        notificationsTableView.registerHeaderView(cell: NotificationHeaderView.self)
        notificationsTableView.delegate = self
    }
    
    @objc func addNotification(){
        coordinator?.showSearchViewController(style: .notification)
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
