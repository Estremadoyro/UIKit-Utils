//
//  CountryCell.swift
//  CountriesInfo
//
//  Created by Leonardo  on 25/01/22.
//

import UIKit

class CountryCellView: UITableViewCell {
  var country: Country? {
    didSet {
      guard let country = country else { return }
      countryName.text = country.name.capitalizingFirstLetter()
    }
  }

  var countryFlagImage: UIImage? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.countryFlag.image = self?.countryFlagImage
      }
    }
  }

  private lazy var cellContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 15
    view.addSubview(countryFlag)
    view.addSubview(countryName)
    view.addSubview(indicatorImage)
    view.backgroundColor = UIColor.white
    return view
  }()

  private lazy var countryName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Peru"
    label.textAlignment = .left
    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: 22)
    return label
  }()

  private let countryFlag: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
//    imageView.image = UIImage(named: "peru.png")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 15
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    return imageView
  }()

  private let indicatorImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "chevron.right")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.borderColor = UIColor.systemPink.cgColor
//    imageView.layer.borderWidth = 2
    return imageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureCell()
    buildSubViews()
    buildConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CountryCellView {
  private func configureCell() {
    selectionStyle = .none
    contentView.backgroundColor = UIColor.systemGray6
  }

  private func buildSubViews() {
    contentView.addSubview(cellContainer)
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      cellContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      cellContainer.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      cellContainer.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 3),
      cellContainer.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -3),

      countryFlag.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor),
      countryFlag.heightAnchor.constraint(equalTo: cellContainer.heightAnchor, multiplier: 0.6),
      countryFlag.leadingAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.leadingAnchor),
      countryFlag.widthAnchor.constraint(equalTo: cellContainer.widthAnchor, multiplier: 0.2),

      countryName.leadingAnchor.constraint(equalTo: countryFlag.trailingAnchor, constant: 15),
      countryName.trailingAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.trailingAnchor),
      countryName.topAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.topAnchor),
      countryName.bottomAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.bottomAnchor),

      indicatorImage.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -20),
      indicatorImage.topAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.topAnchor),
      indicatorImage.bottomAnchor.constraint(equalTo: cellContainer.layoutMarginsGuide.bottomAnchor),
    ])
  }
}
