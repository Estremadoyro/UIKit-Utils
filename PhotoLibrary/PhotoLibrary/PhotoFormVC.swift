//
//  PhotoFormVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 11/01/22.
//

import UIKit

class PhotoFormVC: UIViewController {
  var photoTitle: String {
    get {
      guard let text = titleFieldView.text else { return "" }
      return text
    }
    set {
      titleFieldView.text = newValue
    }
  }

  var photoDescription: String = ""
  var photo: UIImage?

  private var shadowLayer: CAShapeLayer!

  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.addArrangedSubview(titleFieldView)
    stack.addArrangedSubview(descriptionFieldView)
    stack.addArrangedSubview(photoImageView)
    stack.addArrangedSubview(saveButton)
    stack.spacing = 10
    return stack
  }()

  private let titleFieldView: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Title"
    textField.font = UIFont.preferredFont(forTextStyle: .title3)
    textField.textColor = UIColor.black
    textField.layer.cornerRadius = 15
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 2
    textField.setHorizontalPadding(amount: 10)
    return textField
  }()

  private let descriptionFieldView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.preferredFont(forTextStyle: .title3)
    textView.textColor = UIColor.black
    textView.sizeToFit()
    textView.layer.cornerRadius = 15
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 2
//    textView.setHorizontalPadding(amount: 10)
    return textView
  }()

  private let photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    image.clipsToBounds = true
    image.image = UIImage(named: "senku.jpeg")
    image.layer.borderColor = UIColor.black.cgColor
    image.layer.borderWidth = 2
    image.layer.cornerRadius = 15
    return image
  }()

  private let saveButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Save", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    button.backgroundColor = UIColor.systemBlue
    button.layer.cornerRadius = 20
    button.addTarget(self, action: #selector(saveNewPhoto), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    print("form load")
    viewControllerSettings()
    navigationBarSettings()
    subViewsBuilder()
    constraintsBuilder()
  }

  private func viewControllerSettings() {
    modalTransitionStyle = .coverVertical
    view.backgroundColor = UIColor.white
  }

  private func navigationBarSettings() {
    navigationItem.title = "New photo"
    navigationController?.navigationBar.prefersLargeTitles = true
//    let backBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissForm))
    let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.2"), style: .plain, target: self, action: #selector(dismissForm))
    navigationItem.leftBarButtonItems = [backBtn]
  }

  @objc private func dismissForm() {
    navigationController?.popViewController(animated: true)
  }

  private func subViewsBuilder() {
    view.addSubview(stackView)
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
      stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      titleFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.05),
//      descriptionFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.3),
//      photoImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.55),
//      photoImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
    ])
  }
}

extension PhotoFormVC {
  @objc private func saveNewPhoto() {
    guard let title = titleFieldView.text else { return }
    guard let description = descriptionFieldView.text else { return }
    guard !title.isEmpty || !description.isEmpty else { return }
    photoTitle = title
    photoDescription = description
    print("Title: \(photoTitle)")
    print("Description: \(photoDescription)")
  }
}
