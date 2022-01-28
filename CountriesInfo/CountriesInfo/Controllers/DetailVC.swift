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
    view.addSubview(titleFlagImage)
    return view
  }()

  private lazy var titleFlagImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.image = flagImage ?? UIImage(named: "peru.jpeg")
    imageView.layer.cornerRadius = 15
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
//    imageView.backgroundColor = UIColor.systemPink
    return imageView
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
    navigationItem.titleView = titleFlagImage
//    navigationItem.titleView?.addSubview(titleFlagImage)
//    guard let navBarMainView = navigationItem.titleView else { return }
    print("xdd")
//    NSLayoutConstraint.activate([
//      titleFlagImage.centerXAnchor.constraint(equalTo: navBarMainView.centerXAnchor),
//      titleFlagImage.centerYAnchor.constraint(equalTo: navBarMainView.centerYAnchor),
//      titleFlagImage.heightAnchor.constraint(equalTo: navBarMainView.heightAnchor, multiplier: 0.8),
//    ])

//    navigationItem.titleView?.backgroundColor = UIColor.systemPink
//    navigationItem.titleView?.backgroundColor = UIColor.systemPink
  }
}
