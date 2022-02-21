//
//  ViewController.swift
//  TestTableNavigationARC
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  deinit {
    print("root vc deinited")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("\(self) ARC: \(CFGetRetainCount(self))")
  }
}
