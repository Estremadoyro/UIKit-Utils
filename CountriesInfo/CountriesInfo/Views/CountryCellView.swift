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
      countryName.text = country?.name.capitalizingFirstLetter()
    }
  }

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
    imageView.image = UIImage(named: "peru.png")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 15
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
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
  }

  private func buildSubViews() {
    contentView.addSubview(countryName)
    contentView.addSubview(countryFlag)
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      countryFlag.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      countryFlag.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
      countryFlag.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      countryFlag.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),

      countryName.leadingAnchor.constraint(equalTo: countryFlag.trailingAnchor, constant: 15),
      countryName.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      countryName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      countryName.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
    ])
  }
}
