//
//  ViewController.swift
//  UICollectionView
//
//  Created by Leonardo  on 1/01/22.
//

import UIKit

class NavigationVC: UINavigationController {
  private var collectionVC = CollectionVC(collectionViewLayout: UICollectionViewFlowLayout())

  init() {
    super.init(rootViewController: collectionVC)
    print("navigation vc initialized")
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    settings()
    apperance()
  }

  private func settings() {
    navigationBar.prefersLargeTitles = true
  }

  private func apperance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.systemPink
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
}
