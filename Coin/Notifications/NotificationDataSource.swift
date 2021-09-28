//
//  NotificationDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/28.
//

import UIKit

final class NotificationDataSource: NSObject, UITableViewDataSource {
    
    private(set) var notice: [Notice]
    
    override init() {
        self.notice = []
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return notice.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notice[section].numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else {
            return .init()
        }
        let notifications = notice[indexPath.section][indexPath.row]
        cell.configure(from: notifications)
        return cell
    }
    
    func updateDataSource(from notices: [Notice]) {
        self.notice = notices
    }
    
}
