//
//  NotificationsDelegate.swift
//  AssetCatalogButtonsColors
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

extension ViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // get back the user info from scheduled notification
    let userInfo = response.notification.request.content.userInfo
    if let customData = userInfo["dailyReward"] as? String {
      print("Customer data received: \(customData)")
    }
    completionHandler()
  }
}
