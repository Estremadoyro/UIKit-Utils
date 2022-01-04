//
//  CollectionCellView.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import UIKit

class CollectionCellView: UICollectionViewCell {
  let picture: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.clipsToBounds = true
    image.layer.cornerRadius = 15
    image.contentMode = .scaleAspectFill
    image.image = UIImage(named: "senku.png")

    return image
  }()

  let pictureName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Senku"
    label.textAlignment = NSTextAlignment.center
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 22)
//    label.backgroundColor = UIColor.black
    return label
  }()

  override func layoutSubviews() {
    /// # Used the `constraints/anchors` created to determine the `size & positionsuper.layoutSubviews` of any subview
    super.layoutSubviews()
    self.configureCellView()
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    contentView.addSubview(self.picture)
    contentView.addSubview(self.pictureName)
    self.constraintsBuilder()
  }

  private func configureCellView() {
//    contentView.layer.masksToBounds = false
//    contentView.clipsToBounds = true
//    contentView.layer.cornerRadius = 15
//    contentView.layer.shadowRadius = 7
//    contentView.layer.shadowOpacity = 1
//    contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
//    contentView.layer.shadowColor = UIColor.systemPink.cgColor

    let shadowLayer = CAShapeLayer()
    shadowLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 15).cgPath
    shadowLayer.fillColor = UIColor.systemPink.cgColor

    shadowLayer.shadowColor = UIColor.systemPink.cgColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    shadowLayer.shadowOpacity = 1
    shadowLayer.shadowRadius = 5
    contentView.layer.insertSublayer(shadowLayer, at: 0)

    /// # Try to set the `rect` of the view to a `specific value` as shadows are `expensive`
//    contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
    /// # Cache the rendered shadow, prevenets `redrawing`
    contentView.layer.shouldRasterize = true
    /// # Make the cached drawing at the `same scale` of the `main screen`, otherwise it will look `pixelated`
    contentView.layer.rasterizationScale = UIScreen.main.scale
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      self.picture.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      self.picture.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
      self.picture.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      self.picture.topAnchor.constraint(equalTo: contentView.topAnchor),
      self.pictureName.topAnchor.constraint(equalTo: self.picture.bottomAnchor),
      self.pictureName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
      self.pictureName.widthAnchor.constraint(equalTo: self.picture.widthAnchor),
      self.pictureName.centerXAnchor.constraint(equalTo: self.picture.centerXAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
