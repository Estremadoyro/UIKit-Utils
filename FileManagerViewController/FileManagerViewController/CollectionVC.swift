//
//  CollectionVC.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

class CollectionVC: UICollectionViewController {
  private var pictures = [String]()
  private var pictureNames = [String]()

  init(collectionViewLayout layout: UICollectionViewFlowLayout) {
    super.init(collectionViewLayout: layout)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    loadImagesFromBundle()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CollectionCellView.self, forCellWithReuseIdentifier: "Cell")
    print("aaaaaa")
  }

  private func loadImagesFromBundle() {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let strongSelf = self else { return }
      let fm = FileManager.default
      let path = Bundle.main.resourcePath!
      let items = try! fm.contentsOfDirectory(atPath: path)
      for item in items {
        if item.hasPrefix("nssl") {
          strongSelf.pictures.append(item)
          strongSelf.pictureNames.append(strongSelf.removeSuffix(pictureName: item))
        }
      }
      strongSelf.pictures = strongSelf.pictures.sorted(by: { $0 < $1 })
      DispatchQueue.main.async { [weak self] in
        self?.collectionView.reloadData()
      }
    }
  }

  private func removeSuffix(pictureName: String) -> String {
    return pictureName.components(separatedBy: ".")[0]
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailVC = DetailViewController()
    detailVC.selectedImage = pictures[indexPath.item]
    detailVC.picturesList = pictures
    detailVC.currentPicture = indexPath.item + 1
    /// # Push the `DetailViewController`
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pictures.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    guard let customCell = cell as? CollectionCellView else {
      fatalError("FAILED - Creating custom cell, CollectionCellView")
    }
    customCell.pictureNameLabel.text = pictures[indexPath.item]
    return customCell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width * 0.9, height: 100)
  }
}
