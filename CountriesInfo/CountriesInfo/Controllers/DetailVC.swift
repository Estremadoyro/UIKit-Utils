//
//  DetailVC.swift
//  CountriesInfo
//
//  Created by Leonardo  on 27/01/22.
//

import UIKit

final class DetailVC: UIViewController {
  var country: Country
  var flagImage: UIImage?

  init(country: Country, flagImage: UIImage?) {
    self.country = country
    self.flagImage = flagImage
    super.init(nibName: nil, bundle: nil)
  }

  deinit {
    print("deinited \(self)")
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private lazy var navBarView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
    view.addSubview(titleCountryFlagStack)
    return view
  }()

  private lazy var titleCountryFlagStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.backgroundColor = UIColor.systemBlue
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.addArrangedSubview(titleFlagImage)
    stack.addArrangedSubview(titleCountryName)
    return stack
  }()

  private lazy var titleFlagImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleToFill
    imageView.clipsToBounds = true
    imageView.image = flagImage ?? UIImage(named: "peru.jpeg")
    imageView.layer.cornerRadius = 15
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
//    imageView.backgroundColor = UIColor.systemPink
    return imageView
  }()

  private lazy var titleCountryName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = country.name
    label.textAlignment = .center
    label.textColor = UIColor.black
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    return label
  }()
}

extension DetailVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    buildNavBar()
  }
}

extension DetailVC {
  private func buildNavBar() {
    navigationItem.largeTitleDisplayMode = .never
    NSLayoutConstraint.activate([
      titleCountryFlagStack.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
      titleCountryFlagStack.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.6),
      titleCountryFlagStack.topAnchor.constraint(equalTo: navBarView.topAnchor),
      titleCountryFlagStack.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor),

      titleFlagImage.widthAnchor.constraint(equalTo: titleCountryFlagStack.widthAnchor, multiplier: 0.4),
      titleFlagImage.topAnchor.constraint(equalTo: titleCountryFlagStack.topAnchor),
      titleFlagImage.bottomAnchor.constraint(equalTo: titleCountryFlagStack.bottomAnchor),

      titleCountryName.widthAnchor.constraint(equalTo: titleCountryFlagStack.widthAnchor, multiplier: 0.6),
      titleCountryName.topAnchor.constraint(equalTo: titleCountryFlagStack.topAnchor),
      titleCountryName.bottomAnchor.constraint(equalTo: titleCountryFlagStack.bottomAnchor)
    ])
    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCountry))
    navigationItem.rightBarButtonItems = [shareButton]
    navigationItem.titleView = navBarView
  }
}

extension DetailVC {
  @objc
  private func shareCountry() {}
}
