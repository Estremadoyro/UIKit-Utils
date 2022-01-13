//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 8/01/22.
//

import UIKit

class NavigationVC: UINavigationController, UIGestureRecognizerDelegate {
  init() {
    super.init(rootViewController: TableVC())
//    settings()
  }

  private func settings() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.white
    appearance.largeTitleTextAttributes = [.backgroundColor: UIColor.white]
    appearance.titleTextAttributes = [.backgroundColor: UIColor.white]
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
    view.backgroundColor = UIColor.systemGray6
  }

  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    interactivePopGestureRecognizer?.isEnabled = true
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
