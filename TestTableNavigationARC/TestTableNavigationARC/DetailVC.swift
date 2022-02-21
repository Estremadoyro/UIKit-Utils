//
//  DetailVC.swift
//  TestTableNavigationARC
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

class DetailVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("\(self) ARC: \(CFGetRetainCount(self))")
  }

  deinit {
    print("detail vc deinited")
  }
}
