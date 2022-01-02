//
//  ViewController.swift
//  UICollectionView
//
//  Created by Leonardo  on 1/01/22.
//

import UIKit

class NavigationVC: UINavigationController {
  private var collectionVC = CollectionVC(collectionViewLayout: UICollectionViewFlowLayout())

  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    print("navigation vc initialized")
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    settings()
  }

  private func settings() {
    navigationBar.prefersLargeTitles = true
  }
}
