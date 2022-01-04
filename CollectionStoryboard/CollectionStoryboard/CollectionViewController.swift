//
//  CollectionViewController.swift
//  CollectionStoryboard
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

private let reuseIdentifier = "Photo"

class CollectionViewController: UICollectionViewController {
  var photos = [Photo]()

  override func viewDidLoad() {
    super.viewDidLoad()
    readPhotosFromBundle()
    collectionView.delegate = self
    collectionView.dataSource = self
    navigationItem.title = "Storm Viewer SB"
  }

  private func readPhotosFromBundle() {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    for item in items {
      if item.hasPrefix("nssl") {
        photos.append(Photo(image: item, name: item.components(separatedBy: ".")[0]))
      }
    }
  }

  // MARK: UICollectionViewDataSource

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(photos.count)
    return photos.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    let photo = photos[indexPath.item]
    cell.name.text! = photo.name
    print(cell.name.text!)
    return cell
  }
}
