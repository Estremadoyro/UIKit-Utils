//
//  ViewController.swift
//  NotificationsProject
//
//  Created by Leonardo  on 17/02/22.
//

import UIKit
import UserNotifications

/// # ``Local Notifications``
final class ViewController: UIViewController {
  private var notificationTimeInterval: CGFloat = 5.0
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
  }

  @objc
  private func registerLocal() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
      if granted {
        print("owo")
      } else {
        print("sad")
      }
    }
  }

  @objc
  private func scheduleLocal() {
    registerCategories()
    // Defines what is shown inside the alert
    let center = UNUserNotificationCenter.current()
    // Pending notifications, not yet triggered
    center.removeAllPendingNotificationRequests()

    let content = UNMutableNotificationContent()
    content.title = "On the way!"
    content.body = "Dr. Stone, Vol. 20 is on its way!"
    content.categoryIdentifier = "alarm"
    // custom data
    content.userInfo = ["customData": "Mangakasa"]
    content.sound = .default

    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30

    // trigger notification ins a calendar manner
    // The first one runs every day at a specific time
//    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTimeInterval, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request, withCompletionHandler: nil)
  }

  // register button categories (action buttons grouped)
  private func registerCategories() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self

    let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
    let remindLater = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: .foreground)
    // will connect to the notification already created by id: "alarm"
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [], options: [])

    center.setNotificationCategories([category])
  }
}

extension ViewController: UNUserNotificationCenterDelegate {
  // User launches app as result of notification
  // userInfo gets handed back, chance link notification to any app content it relates to
  // Decide what to do based on the user's choice
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Getting back the userinfo
    let userInfo = response.notification.request.content.userInfo
    if let customData = userInfo["customData"] as? String {
      print("Custom data recieved: \(customData)")

      switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
          // user openning the app from the notification interface
          let ac = UIAlertController(title: "Notification", message: "Accessed from default action", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
          present(ac, animated: true)
          print("default identifier")
        case "show":
          // user tapped the show more info button explecitly
          let ac = UIAlertController(title: "Notification", message: "Accessed from tell more button", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
          present(ac, animated: true)
          print("Show more info...")
        case "remindLater":
          // user tapped remind later
          let ac = UIAlertController(title: "Notification", message: "Accessed from remind later button", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
          present(ac, animated: true)
          notificationTimeInterval = 6
          scheduleLocal()

        default:
          break
      }
    }
    // Finished handling the notification response
    completionHandler()
  }
}
