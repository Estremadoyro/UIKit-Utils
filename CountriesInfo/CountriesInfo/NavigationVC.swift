//
//  NavigationVC.swift
//  CountriesInfo
//
//  Created by Leonardo  on 25/01/22.
//

import UIKit

final class NavigationVC: UINavigationController {
  private let tableVC: UIViewController = {
    let table = TableVC()
    return table
  }()

  init() {
    super.init(rootViewController: tableVC)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
