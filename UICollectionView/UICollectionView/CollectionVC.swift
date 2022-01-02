//
//  CollectionVC.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionVC: UICollectionViewController {
  override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Contacts"
    navigationItem.largeTitleDisplayMode = .always

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Register cell classes
    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }

  // MARK: UICollectionViewDataSource

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    cell.backgroundColor = UIColor.systemBlue
    return cell
  }
}
