//
//  SetViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/22.
//

import UIKit

final class SetViewController: UIViewController {
    
    private let setTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(setTableView)
        
        NSLayoutConstraint.activate([
            setTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            setTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            setTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            setTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        setTableView.dataSource = self
        setTableView.delegate = self
        setTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setNotification() {
        guard let bundle = Bundle.main.bundleIdentifier,
              let settings = URL(string: UIApplication.openSettingsURLString + bundle) else {
            return
        }
        if UIApplication.shared.canOpenURL(settings) {
            UIApplication.shared.open(settings)
        }
    }
    
    private func sendEmail() {
    }
}

extension SetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "알림 설정"
        } else {
            cell.textLabel?.text = "의견 보내기"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            setNotification()
        } else {
            
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

