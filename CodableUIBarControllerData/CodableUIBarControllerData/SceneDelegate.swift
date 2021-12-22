//
//  SceneDelegate.swift
//  CodableUIBarControllerData
//
//  Created by Leonardo  on 19/12/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  /// # Window in which the app is currently running, it can be nil, as the app can be `running in the background` and there will be no `windows` currently open
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }

    /// ``Override point for customization after application launch.``
    /// # Safe cast the `rootViewController`, in this case is `UITabBarController`
    /// # ``window`` current window
    /// # Will `always` be `UITabController` unless the app is running in `background`
    /// # ``rootViewController`` the root view controller defined, `UITabController`.
    /// # ``as?`` is `attempting` to downcast a `UIViewController hirarchy type` (It can be UINavigation, UITable) to `UITabBarController`
    /// # It will be ``nil`` if the `downcasting` was `NOT POSSIBLE` (aka `rootViewController` not being a `superClass` of `UITabBarController`
    if let tabBarController = window?.rootViewController as? UITabBarController {
      /// # Instantiate the `Main storyboard`
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      /// # Create a `new` instance of `NavigatonViewController`
      let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
      /// # Set the 2nd `tabBarItem` (Index 1), 2 in total, and the `icon`
      vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1) /// # `1` is the `2nd` tab bar item
      /// # Append the new `NavigationViewController` to the `tabBarController` from the `UITabBarController`
      tabBarController.viewControllers?.append(vc)
      /// #
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}
