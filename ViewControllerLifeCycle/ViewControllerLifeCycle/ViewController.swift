//
//  ViewController.swift
//  ViewControllerLifeCycle
//
//  Created by Leonardo  on 15/01/22.
//

import UIKit

class ViewController: UIViewController {
  private lazy var nameTextField = UITextField()

  init() {
    super.init(nibName: nil, bundle: nil)
    print("initialized")
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemPink
    configureNameTextField()
    view.addSubview(nameTextField)
    constraintsBuilder()
  }

  private func configureNameTextField() {
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    nameTextField.textColor = UIColor.black
    nameTextField.font = UIFont.systemFont(ofSize: 22)
    nameTextField.layer.borderColor = UIColor.black.cgColor
    nameTextField.layer.borderWidth = 2
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
      nameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
    ])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("view will appear")
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    print("view will layout subviews")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print("view did layout subviews")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("view did appear")
  }
}
