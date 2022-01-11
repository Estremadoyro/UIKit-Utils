//
//  CellView.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 10/01/22.
//

import UIKit

class CellView: UITableViewCell {
  private var shadowLayer: CAShapeLayer!
  private var shadowRadius: CGFloat = 3.0
  private let photoNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Byakuya"
    label.textColor = UIColor.black.withAlphaComponent(0.8)
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    return label
  }()

  private let photoCaptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "'If you are serious, you can accomplish anything throught dilligent application of science'"
    label.textColor = UIColor.gray.withAlphaComponent(0.8)
    label.font = UIFont.italicSystemFont(ofSize: 13)
    label.numberOfLines = 3
    return label
  }()

  private lazy var cellContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
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
    contentView.addSubview(cellContainer)
    constraintsBuilder()
  }

  private func setupCell() {
    selectionStyle = .none
  }

  func setupContentView() {
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.shadowLayer = CAShapeLayer()
      strongSelf.shadowLayer.path = UIBezierPath(roundedRect: strongSelf.cellContainer.bounds, cornerRadius: 10).cgPath
      strongSelf.shadowLayer.fillColor = UIColor.white.cgColor
      strongSelf.shadowLayer.shadowColor = UIColor.black.cgColor
      strongSelf.shadowLayer.shadowPath = strongSelf.shadowLayer.path
      strongSelf.shadowLayer.shadowOffset = .zero
      strongSelf.shadowLayer.shadowOpacity = 0.2
      strongSelf.shadowLayer.shadowRadius = strongSelf.shadowRadius
      strongSelf.cellContainer.layer.insertSublayer(strongSelf.shadowLayer, at: 0)
    }
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      cellContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      cellContainer.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      cellContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      stackView.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -10),
      stackView.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
