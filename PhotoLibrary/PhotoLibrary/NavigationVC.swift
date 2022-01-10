//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 8/01/22.
//

import UIKit

class NavigationVC: UINavigationController {
  init() {
    super.init(rootViewController: TableVC())
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemGray6
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
