//
//  NotificationService.swift
//  AssetCatalogButtonsColors
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit
import UserNotifications

final class NotificationService {
  private static let CATEGORY_IDENTIFIER: String = "alarm"
  public static func grantNotificationPermissions() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        print(error)
        return
      }

      if granted {
        print("Granted access to send local notifications")
        // Notify of daily alerts
//        let ac = UIAlertController(title: "Notifications", message: "Congratzs! You will now recieve daily reminders", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Great", style: .cancel, handler: nil))
        print("called once, should never be called again")
        return
      } else {
        print("Notifications access denied")
        return
      }
    }
    NotificationService.scheduleLocalNotifications()
  }
}

extension NotificationService {
  public static func scheduleLocalNotifications() {
    let center = UNUserNotificationCenter.current()
    // remove pending notifications that were never shown
    center.removeAllPendingNotificationRequests()

    let content = UNMutableNotificationContent()
    content.title = "Daily reward"
    content.body = "Come back and claim your daily reward"
    content.categoryIdentifier = NotificationService.CATEGORY_IDENTIFIER
    content.userInfo = ["dailyReward": "+100 gems"]
    content.sound = .default

    /// # Considering: `10 seconds = 24hrs`
    // once per day of the week, without the current day ofc
    for i in 1 ... 6 {
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0 * CGFloat(i), repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      // schedules local notification for delivery
      center.add(request, withCompletionHandler: nil)
    }
    center.getPendingNotificationRequests { notifications in
      notifications.forEach { notification in
        print(notification.trigger)
      }
    }
  }
}
