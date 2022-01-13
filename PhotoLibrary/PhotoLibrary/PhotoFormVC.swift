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

  let photoDescriptionPlaceholder: String = "Description"

  private var shadowLayer: CAShapeLayer!
  private var gestureRecognizer: UITapGestureRecognizer!

  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.alwaysBounceVertical = true
    scroll.addSubview(containerView)
    return scroll
  }()

  private lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(fullStackView)
//    view.addSubview(saveButton)
    return view
  }()

  private lazy var fullStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalCentering
    stack.spacing = 10
    stack.addArrangedSubview(photoImageView)
    stack.addArrangedSubview(stackView)
    return stack
  }()

  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fill
    stack.spacing = 10
    stack.addArrangedSubview(titleFieldView)
    stack.addArrangedSubview(descriptionFieldView)
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

  private lazy var descriptionFieldView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.preferredFont(forTextStyle: .title3)
    textView.textColor = UIColor.lightGray
    textView.layer.cornerRadius = 15
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 2
    textView.text = photoDescriptionPlaceholder
    textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    return textView
  }()

  private let photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFill
    image.clipsToBounds = true
    image.image = UIImage(named: "no-image-found.jpeg")
    image.layer.borderColor = UIColor.black.cgColor
    image.layer.borderWidth = 2
    image.layer.cornerRadius = 15
    return image
  }()

  private lazy var saveButtonContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    view.addSubview(saveButton)
    return view
  }()

  private let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Save", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
    button.backgroundColor = UIColor.systemBlue
    button.layer.cornerRadius = 15
    button.addTarget(self, action: #selector(saveNewPhoto), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    titleFieldView.text = ""
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    print("form load")
    descriptionFieldView.delegate = self
    viewControllerSettings()
    navigationBarSettings()
    subViewsBuilder()
    constraintsBuilder()
    setupGestures()
  }

  private func viewControllerSettings() {
    modalTransitionStyle = .coverVertical
    view.backgroundColor = UIColor.white
  }

  @objc private func dismissForm() {
    navigationController?.popViewController(animated: true)
  }

  private func subViewsBuilder() {
    view.addSubview(scrollView)
    view.addSubview(saveButtonContainerView)
//    view.addSubview(fullStackView)
//    view.addSubview(saveButton)
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

      containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      fullStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
      fullStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.6),
      fullStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      fullStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

      photoImageView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.6, constant: -10),
      stackView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.4),

      titleFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),
      descriptionFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8, constant: -10),

      saveButtonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      saveButtonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      saveButtonContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      saveButtonContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.09),

      saveButton.leadingAnchor.constraint(equalTo: saveButtonContainerView.layoutMarginsGuide.leadingAnchor),
      saveButton.trailingAnchor.constraint(equalTo: saveButtonContainerView.layoutMarginsGuide.trailingAnchor),
      saveButton.topAnchor.constraint(equalTo: saveButtonContainerView.topAnchor, constant: 5),
      saveButton.bottomAnchor.constraint(equalTo: saveButtonContainerView.bottomAnchor, constant: -25),

//      fullStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//      fullStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
//      fullStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//      fullStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//
//      photoImageView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.6, constant: -10),
//      stackView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.4),
//
//      titleFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),
//      descriptionFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8, constant: -10),
//
//      saveButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//      saveButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//      saveButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
//      saveButton.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.07),
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

extension PhotoFormVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if descriptionFieldView.textColor == UIColor.lightGray {
      descriptionFieldView.text = ""
      descriptionFieldView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if descriptionFieldView.text.isEmpty {
      descriptionFieldView.text = photoDescriptionPlaceholder
      descriptionFieldView.textColor = UIColor.lightGray
    }
  }
}

extension PhotoFormVC {
  func setupGestures() {
    gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
    gestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(gestureRecognizer)
  }

  @objc func dismissKeyboardTouchOutside() {
    view.endEditing(true)
  }
}

extension PhotoFormVC {
  func navigationBarSettings() {
    navigationItem.title = "New photo"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.2"), style: .plain, target: self, action: #selector(dismissForm))
    navigationItem.leftBarButtonItems = [backBtn]
  }
}
