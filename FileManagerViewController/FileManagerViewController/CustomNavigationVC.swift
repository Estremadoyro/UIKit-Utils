//
//  CustomNavigationVC.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

class CustomNavigationVC: UINavigationController {
  private var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 30
    return layout
  }()

  init() {
    super.init(rootViewController: CollectionVC(collectionViewLayout: layout))
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    apperance()
  }
  
  private func apperance() {
    let apperance = UINavigationBarAppearance()
    apperance.backgroundColor = UIColor.black
    UINavigationBar.appearance().standardAppearance = apperance
    UINavigationBar.appearance().scrollEdgeAppearance = apperance
    UINavigationBar.appearance().compactAppearance = apperance
  }
}
