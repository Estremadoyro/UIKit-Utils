//
//  ViewController.swift
//  Sandbox-CompositionalLayout
//
//  Created by Leonardo  on 1/06/22.
//

import UIKit

final class ViewController: UIViewController {
  @IBOutlet private weak var collectionView: UICollectionView!

  private let images: [UIImage] = Array(1 ... 11).map { UIImage(named: String($0))! }
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.collectionViewLayout = createLayout()
  }

  // MARK: - UICollectionViewCompositionalLayout

  private func createLayout() -> UICollectionViewCompositionalLayout {
    /// # Elements have to be created from the inside-outside
    // Item
    /// # FractionalWidth: `Fraction height/width of the CONTAINIG group`
    let item = CustomCompositionalLayout.createItem(
      width: .fractionalWidth(0.5),
      height: .fractionalHeight(1),
      spacing: 1
    )
    let fullItem = CustomCompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)

    let verticalGroup = CustomCompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 3)

    // Group
    // Full size of the CollectionView
    /// Custom group: Group [Item, VerticalGroup[fullItem, fullItem]
    let group = CustomCompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), items: [item, verticalGroup])

    // Section
    let section = NSCollectionLayoutSection(group: group)

    // Compositional layout
    let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
    return compositionalLayout
  }
}

// MARK: - UICollectionView datasource/jdelegates

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? MyCollectionViewCell else {
      fatalError("Error dequeing cell")
    }
    cell.setup(image: images[indexPath.row])
    return cell
  }
}

final class MyCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var cellImageView: UIImageView!

  func setup(image: UIImage) {
    cellImageView.image = image
  }
}
