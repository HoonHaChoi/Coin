//
//  NotificationsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

final class NotificationsViewController: UIViewController {
    
    private let dataSource: NotificationDataSource
    private let imageLoader: Loader
    weak var coordinator: NotificationsCoordinator?
        
    init(dataSource: NotificationDataSource,
         imageLoader: Loader) {
        self.dataSource = dataSource
        self.imageLoader = imageLoader
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
        table.estimatedRowHeight = 60
        table.rowHeight = 60
        table.sectionHeaderHeight = 50
        table.sectionFooterHeight = 1
        table.allowsSelection = false
        table.delaysContentTouches = false
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        return refresh
    }()
    
    private let emptyView: EmptyView = {
        let empty = EmptyView(frame: .zero , title: "알림 목록이 비어 있어요!",
                              description: "+버튼으로 원하는 금액에 도달하는 코인을 \n 등록하고 알림을 받아보세요")
        empty.isHidden = true
        empty.translatesAutoresizingMaskIntoConstraints = false
        return empty
    }()
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var requestNotifications: (() -> ())?
    var requestDeleteNotification: ((String) -> ())?
    var requestUpdateSwitch: ((String, Bool, IndexPath) -> ())?
    
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
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            notificationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        notificationsTableView.registerClass(cell: NotificationCell.self)
        notificationsTableView.registerHeaderView(cell: NotificationHeaderView.self)
        notificationsTableView.dataSource = dataSource
        notificationsTableView.delegate = self
        notificationsTableView.addSubview(refreshControl)
    }
    
    @objc func refreshTableView(_ sender: UIRefreshControl) {
        requestNotifications?()
    }
    
    @objc func addNotification(){
        coordinator?.showSearchViewController(style: .notification)
    }
    
    lazy var updateNotifications: ([Notice]) -> () = { [weak self] notifiactions in
        self?.dataSource.updateDataSource(from: notifiactions)
        DispatchQueue.main.async {
            self?.notificationsTableView.reloadData()
            self?.changeTableViewState()
        }
    }
    
    private func changeTableViewState() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        if dataSource.notice.isEmpty {
            notificationsTableView.isHidden = true
            emptyView.isHidden = false
        } else {
            notificationsTableView.isHidden = false
            emptyView.isHidden = true
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
    
    func receiveSwitchAction(cell: NotificationCell, switch state: Bool) {
        guard let indexPath = notificationsTableView.indexPath(for: cell) else {
            return
        }
        let notificationUUID = dataSource.notice[indexPath.section][indexPath.row].uuid
        requestUpdateSwitch?(notificationUUID, state, indexPath)
    }
    
    func restoreSetSwitch(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let cell = self?.notificationsTableView.cellForRow(at: indexPath) as? NotificationCell else {
                return
            }
            cell.restoreSwitch()
        }
    }
    
    private func showCreateInputView(from notification: NotificationObject) {
        coordinator?.showCreateNotificationInputViewController(from: notification)
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tickerUUID = dataSource.notice[indexPath.section].uuid
        let notification = dataSource.notice[indexPath.section][indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, complete  in
            let confirmAlert = UIAlertController().deleteNotifiationAlert() { _ in
                self?.requestDeleteNotification?(notification.uuid)
                complete(true)
            }
            self?.present(confirmAlert, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, complete in
            let notiObject = NotificationObject(type: notification.type,
                                                basePrice: Int(notification.basePrice) ?? 0,
                                                tickerUUID: tickerUUID,
                                                notificationUUID: notification.uuid,
                                                notificationCycleUUID: notification.notificationCycle.displayCycle)
            self?.coordinator?.showUpdateNotificationInputViewController(from: notiObject)
            complete(true)
        }
        
        deleteAction.backgroundColor = .systemBackground
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.riseColor, renderingMode: .alwaysOriginal)
        
        editAction.backgroundColor = .systemBackground
        editAction.image = UIImage(systemName: "square.and.pencil")?.withTintColor(.fallColor, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NotificationHeaderView.reuseIdentifier) as? NotificationHeaderView else {
            return .init()
        }
        
        let crypto = dataSource.notice[section]
        let notiObject = NotificationObject.create(crypto.uuid)
        header.configure(crypto: crypto, imageLoader: imageLoader)
        
        header.addButtonAction = { [weak self] in
            self?.showCreateInputView(from: notiObject)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separtorView = UIView(frame: CGRect(x: .zero, y: .zero, width: tableView.frame.width, height: 1))
        separtorView.backgroundColor = .DEDEDE
        return separtorView
    }
}
