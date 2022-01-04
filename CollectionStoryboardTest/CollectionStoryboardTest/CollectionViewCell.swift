//
//  CollectionViewCell.swift
//  CollectionStoryboardTest
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var name: UILabel!
  func configure(with name: String) {
    self.name.text = name
  }
}
