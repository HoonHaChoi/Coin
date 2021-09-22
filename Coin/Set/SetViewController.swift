//
//  SetViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/22.
//

import UIKit
import MessageUI

final class SetViewController: UIViewController {
    
    private let setTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private let cellIdentifier = "cell"
    
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
        setTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
    
    private func showMailComposer(){
        guard MFMailComposeViewController.canSendMail() else {
            showErrorAlert(message: "문제가 발생하였습니다. 메일앱 확인해주세요")
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["chlgnsgk@gmail.com"])
        composer.setSubject("[코인일지] 의견 보내기")
        present(composer, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류발생", message: message)
        present(alert, animated: true)
    }
}

extension SetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
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
            showMailComposer()
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension SetViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true) {
                self.showErrorAlert(message: "문제가 발생하였습니다. 잠시후 시도해주세요.")
            }
            return
        }
        controller.dismiss(animated: true) {
            let successAlert = UIAlertController(title: "의견을 보내주셔서 감사합니다", message: "")
            self.present(successAlert, animated: true)
        }
    }
}
