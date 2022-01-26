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
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      countryName.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      countryName.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      countryName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
      countryName.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
    ])
  }
}
