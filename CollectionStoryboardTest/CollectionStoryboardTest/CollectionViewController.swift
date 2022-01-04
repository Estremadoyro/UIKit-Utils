//
//  CollectionViewController.swift
//  CollectionStoryboardTest
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Test"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell else {
      fatalError("Error finding CollectionViewCell")
    }
    cell.name.text = "Senkuuuu"

    return cell
  }
}
