//
//  CellView.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 10/01/22.
//

import UIKit

class CellView: UITableViewCell {
  private var cellContainerLayer: CAShapeLayer!
//  let noPhoto = Photo(name: "Byakuya",
//                      caption: " 'If you are serious, you can accomplish anything throught dilligent application of science'",
//                      url: "no-image-found.jpeg")

  let photoThumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 10
    imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    return imageView
  }()

  lazy var photoNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.black.withAlphaComponent(0.8)
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()

  let photoCaptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.gray.withAlphaComponent(0.8)
    label.font = UIFont.italicSystemFont(ofSize: 13)
    label.numberOfLines = 3
    return label
  }()

  private lazy var cellContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(photoThumbnail)
    view.addSubview(stackView)
    return view
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.addArrangedSubview(photoNameLabel)
    stackView.addArrangedSubview(photoCaptionLabel)
    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
    setupContentView()
    constraintsBuilder()
    applyLayers()
  }

  private func setupCell() {
    selectionStyle = .none
  }

  func setupContentView() {
    contentView.addSubview(cellContainer)
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      cellContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      cellContainer.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      cellContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

      photoThumbnail.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor),
      photoThumbnail.topAnchor.constraint(equalTo: cellContainer.topAnchor),
      photoThumbnail.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor),
      photoThumbnail.widthAnchor.constraint(equalTo: cellContainer.widthAnchor, multiplier: 0.2),

      stackView.leadingAnchor.constraint(equalTo: photoThumbnail.trailingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -10),
      stackView.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor)
    ])
  }

  private func applyLayers() {
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.cellContainerLayer = strongSelf.cellContainer.addShadowAndCorners(fillColor: UIColor.white.cgColor, cornerRadius: 10, shadowColor: UIColor.black.cgColor, shadowOffset: .zero, shadowOpacity: 0.2, shadowRadius: 3.0)
      strongSelf.cellContainer.layer.insertSublayer(strongSelf.cellContainerLayer, at: 0)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("deinit \(self)")
  }
}
