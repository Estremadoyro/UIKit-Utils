//
//  CellView.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 10/01/22.
//

import UIKit

class CellView: UITableViewCell {
  private let photoNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Dr. Stone"
    label.textColor = UIColor.systemBlue
    label.font = UIFont.systemFont(ofSize: 22)
//    label.layer.borderColor = UIColor.systemPink.cgColor
//    label.layer.borderWidth = 1
    return label
  }()

  private let photoCaptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "If you are serious, you can accomplish anything through dilligent applicatoin of sciente"
    label.textColor = UIColor.gray.withAlphaComponent(0.8)
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    return label
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
  }

  private func setupCell() {
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
//      stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
