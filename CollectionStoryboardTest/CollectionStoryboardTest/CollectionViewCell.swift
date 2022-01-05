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
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    NSLayoutConstraint.activate([
      contentView.centerXAnchor.constraint(equalTo: )
    ])
  }
}
