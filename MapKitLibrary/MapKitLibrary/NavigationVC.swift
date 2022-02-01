//
//  ViewController.swift
//  MapKitLibrary
//
//  Created by Leonardo  on 1/02/22.
//

import UIKit

class NavigationVC: UINavigationController {
  private var mainVC: UIViewController = {
    let vc = MainVC()
    return vc
  }()

  init() {
    super.init(rootViewController: mainVC)
    configureNavigation()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigation() {
    navigationBar.prefersLargeTitles = true
  }
}
