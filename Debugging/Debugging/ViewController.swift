//
//  ViewController.swift
//  Debugging
//
//  Created by Leonardo  on 6/02/22.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .dark

    print(1, 2, 3, 4, 5, separator: "-", terminator: "\n")

    // (boolean test, THEN)
    assert(1 == 1, "Math error!")
//    assert(1 == 2, "Math error!")

    for i in 1 ... 100 {
      print("Number: \(i)")
    }
  }
}
