//
//  CollectionCellView.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import UIKit

class CollectionCellView: UICollectionViewCell {
  private let picture: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFill
    image.image = UIImage(named: "senku.png")
    image.clipsToBounds = true
    return image
  }()

  private let pictureName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Senku"
    label.textAlignment = NSTextAlignment.center
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 22)
    label.layer.borderWidth = 2
    label.layer.borderColor = UIColor.white.cgColor
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
    contentView.addSubview(picture)
    contentView.addSubview(pictureName)
    constraintsBuilder()
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      picture.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
      picture.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
      picture.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      picture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      pictureName.topAnchor.constraint(equalTo: picture.bottomAnchor),
      pictureName.widthAnchor.constraint(equalTo: picture.widthAnchor),
      pictureName.centerXAnchor.constraint(equalTo: picture.centerXAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
