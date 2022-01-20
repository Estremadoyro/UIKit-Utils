//
//  ViewController.swift
//  CoreImageSlider
//
//  Created by Leonardo  on 19/01/22.
//

import UIKit

class MainVC: UIViewController {
  lazy var mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    return stack
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemGray6
    configNavbar()
    setupSubViews()
    setupConstraints()
  }
}

extension MainVC {
  private func configNavbar() {
    title = "Photo Editor"
  }

  private func setupSubViews() {
    view.addSubview(mainStackView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
  }
}
