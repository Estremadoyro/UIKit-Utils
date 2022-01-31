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
//    view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
    view.addSubview(titleCountryFlagStack)
    return view
  }()

  private lazy var titleCountryFlagStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.spacing = 5
    stack.translatesAutoresizingMaskIntoConstraints = false
//    stack.backgroundColor = UIColor.systemBlue
    stack.addArrangedSubview(titleFlagImageContainer)
    stack.addArrangedSubview(titleCountryName)
    return stack
  }()

  private lazy var titleFlagImageContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleFlagImage)
    return view
  }()

  private lazy var titleFlagImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = flagImage ?? UIImage(named: "peru.jpeg")
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    imageView.layer.cornerRadius = 15
    return imageView
  }()

  private lazy var titleCountryName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = country.name
    label.textAlignment = .left
    label.textColor = UIColor.black
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    return label
  }()

  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.alwaysBounceVertical = true
    scroll.delaysContentTouches = true
    scroll.addSubview(mainStackView)
    return scroll
  }()

  private lazy var mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fill
    return stack
  }()
}

extension DetailVC {
  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = UIColor.systemGray6
    view.backgroundColor = UIColor.white
    view.addSubview(scrollView)
    buildConstraints()
    buildNavBar()
    buildCountryInfoSubViews()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if mainStackView.arrangedSubviews.first?.frame == .zero {
      mainStackView.superview?.setNeedsLayout()
      DispatchQueue.main.async { [weak self] in
        self?.mainStackView.subviews.forEach { subView in
          subView.addShadowAndCorners(fillColor: UIColor.white, cornerRadius: 15, shadowColor: UIColor.black.cgColor, shadowOffset: .zero, shadowOpacity: 0.2, shadowRadius: 3)
        }
        print("didlayout subviews")
      }
    }
  }
}

extension DetailVC {
  private func configureCountryInfoSubViews(_ countryProperty: Mirror.Child, _ index: Int, _ container: UIView, _ icon: UIImageView, _ info: UILabel) {
    container.translatesAutoresizingMaskIntoConstraints = false
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.clipsToBounds = true
    icon.contentMode = .scaleAspectFit
    icon.image = UIImage(systemName: Constants.COUNTRY_INFO_ICONS[index])
    icon.tintColor = UIColor.systemBlue
    info.translatesAutoresizingMaskIntoConstraints = false
    info.textColor = UIColor.systemBlue
    info.font = UIFont.preferredFont(forTextStyle: .title1)
    info.text = "\(countryProperty.value)"
  }

  private func buildCountryInfoSubViews() {
    let mirroredCountry = Mirror(reflecting: country)
    let filteredMirroredCountry = mirroredCountry.children.filter { $0.label != "name" && $0.label != "flag" }

    for (index, countryProperty) in filteredMirroredCountry.enumerated() {
      let container = UIView()
      let icon = UIImageView()
      let info = UILabel()
      configureCountryInfoSubViews(countryProperty, index, container, icon, info)
      container.addSubview(icon)
      container.addSubview(info)
      mainStackView.addArrangedSubview(container)
      NSLayoutConstraint.activate([
        container.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1),

        icon.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        icon.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.2),
        icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
        icon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15),

        info.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
        info.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        info.topAnchor.constraint(equalTo: container.topAnchor),
        info.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      ])
    }
  }

  private func buildConstraints() {
    buildNavBarContraints()
    buildDetailConstraints()
  }
}

extension DetailVC {
  private func buildNavBarContraints() {
    NSLayoutConstraint.activate([
      titleCountryFlagStack.topAnchor.constraint(equalTo: navBarView.topAnchor),
      titleCountryFlagStack.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: -5),
      titleCountryFlagStack.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor),
      titleCountryFlagStack.widthAnchor.constraint(equalTo: navBarView.widthAnchor, multiplier: 0.8),

      titleFlagImageContainer.topAnchor.constraint(equalTo: titleCountryFlagStack.topAnchor),
      titleFlagImageContainer.bottomAnchor.constraint(equalTo: titleCountryFlagStack.bottomAnchor),
      titleFlagImageContainer.widthAnchor.constraint(equalTo: titleCountryFlagStack.widthAnchor, multiplier: 0.5, constant: -5),

      titleCountryName.topAnchor.constraint(equalTo: titleCountryFlagStack.topAnchor),
      titleCountryName.bottomAnchor.constraint(equalTo: titleCountryFlagStack.bottomAnchor),
      titleCountryName.widthAnchor.constraint(equalTo: titleCountryFlagStack.widthAnchor, multiplier: 0.5, constant: 0),

      titleFlagImage.topAnchor.constraint(equalTo: titleCountryFlagStack.topAnchor),
      titleFlagImage.bottomAnchor.constraint(equalTo: titleCountryFlagStack.bottomAnchor),
      titleFlagImage.widthAnchor.constraint(equalTo: titleFlagImageContainer.widthAnchor, multiplier: 0.6),
      titleFlagImage.trailingAnchor.constraint(equalTo: titleFlagImageContainer.trailingAnchor),

    ])
  }

  private func buildNavBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.titleView = navBarView

    let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCountry))
    navigationItem.rightBarButtonItems = [shareButton]
  }
}

extension DetailVC {
  private func buildDetailConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

      mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95),
      mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),

    ])
  }
}

extension DetailVC {
  @objc
  private func shareCountry() {
    guard let flag = flagImage else { return }
    let detailedItem = """
    \(country.name)
    Capital city: \(country.capital)
    Population: \(country.population)
    Currency: \(country.currency)
    Area: \(country.area_km) km
    """
    let ac = UIActivityViewController(activityItems: [detailedItem, flag], applicationActivities: nil)
    // prevents crashing on ipad
    ac.popoverPresentationController?.sourceView = view
    ac.isModalInPresentation = true
    present(ac, animated: true, completion: nil)
  }
}
