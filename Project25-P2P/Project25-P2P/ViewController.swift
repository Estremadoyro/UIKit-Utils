//
//  ViewController.swift
//  Project25-P2P
//
//  Created by Leonardo  on 14/03/22.
//

import UIKit

final class ViewController: UICollectionViewController {
  private var photoPicker: PhotoPicker?
  private var images = [UIImage]()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavBar()
  }
}

extension ViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }

    return cell
  }
}

private extension ViewController {
  func configureNavBar() {
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
  }
}

private extension ViewController {
  @objc
  func importPicture() {
    photoPicker = PhotoPicker()
    photoPicker?.photoPickerDelegate = self

    guard let photoPickerVC = photoPicker?.photoPickerVC else { return }
    present(photoPickerVC, animated: true)
  }
}

extension ViewController: PhotoPickerDelegate {
  func didSelectPhoto(photo: UIImage) {
    photoPicker = nil // clean up
    print("photo selected: \(photo)")
    images.insert(photo, at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    collectionView.insertItems(at: [indexPath])
  }
}
