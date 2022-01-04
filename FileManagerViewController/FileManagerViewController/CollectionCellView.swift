//
//  CollectionCellView.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 4/01/22.
//

import UIKit

class CollectionCellView: UICollectionViewCell {
  var pictureNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Dr. Stone"
    label.font = UIFont.systemFont(ofSize: 22)
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.backgroundColor = UIColor.systemBlue
    label.layer.cornerRadius = 15
    label.clipsToBounds = true
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
    addSubview(pictureNameLabel)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    constraintsBuilder()
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      pictureNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      pictureNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      pictureNameLabel.widthAnchor.constraint(equalTo: widthAnchor),
      pictureNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
