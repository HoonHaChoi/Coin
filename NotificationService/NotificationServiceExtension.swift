//
//  NotificationService.swift
//  NotificationService
//
//  Created by HOONHA CHOI on 2021/10/05.
//

import UserNotifications

class NotificationServiceExtension: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            return
        }
        
        let image = request.content.userInfo["fcm_options"] as? [String: Any]
        guard let urlImageString = image?["image"] as? String,
              let url = URL(string: urlImageString),
              let attachment = fetchImage(url: url) else {
            contentHandler(bestAttemptContent)
            return
        }
        bestAttemptContent.attachments = [attachment]
        contentHandler(bestAttemptContent)
    }

    private func fetchImage(url: URL) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let appIdentifier = "group.hoonha.Coin"
        
        let originalURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appIdentifier)!.appendingPathComponent(url.lastPathComponent)
        
        let copyImageURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(url.lastPathComponent)
        
        if !fileManager.fileExists(atPath: copyImageURL.path) {
            try? fileManager.copyItem(at: originalURL, to: copyImageURL)
        }

        guard let attachment = try? UNNotificationAttachment(identifier: url.lastPathComponent,
                                                             url: copyImageURL,
                                                             options: nil) else {
            return nil
        }
        return attachment
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
