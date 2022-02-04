//
//  ViewController.swift
//  MapKitLibrary
//
//  Created by Leonardo  on 1/02/22.
//

import UIKit

class NavigationVC: UINavigationController {
  init() {
    super.init(rootViewController: MainVC())
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
