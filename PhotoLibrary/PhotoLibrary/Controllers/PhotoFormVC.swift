//
//  PhotoFormVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 11/01/22.
//

import UIKit

class PhotoFormVC: UIViewController {
  weak var photoPickerDelegate: PhotoPickerDelegate?
  weak var photoPickerDataSource: PhotoPickerDataSource?

  var photo: UIImage?

  private var saveButtonLayer: CAShapeLayer!
  private var gestureRecognizer: UITapGestureRecognizer!
  private var createdNewPhoto: Photo?

  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.alwaysBounceVertical = true
    scroll.addSubview(fullStackView)
    scroll.delaysContentTouches = true
    return scroll
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
    stack.spacing = 5
    stack.addArrangedSubview(titleLabel)
    stack.addArrangedSubview(titleFieldView)
    stack.addArrangedSubview(descriptionLabel)
    stack.addArrangedSubview(descriptionFieldView)
    return stack
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Title"
    label.textColor = UIColor.black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Description"
    label.textColor = UIColor.black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()

  private lazy var titleFieldView: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = UIFont.preferredFont(forTextStyle: .title3)
    textField.textColor = UIColor.black
    textField.layer.cornerRadius = 15
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 2
    textField.delegate = self
    textField.setHorizontalPadding(amount: 10)
    return textField
  }()

  private lazy var descriptionFieldView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = UIFont.preferredFont(forTextStyle: .title3)
    textView.textColor = UIColor.black
    textView.layer.cornerRadius = 15
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 2
    textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    textView.delegate = self
    return textView
  }()

  private let photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFill
    image.clipsToBounds = true
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
    button.addTarget(self, action: #selector(saveNewPhoto), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    print("view did load")
    view.backgroundColor = UIColor.white
    viewControllerSettings()
    navigationBarSettings()
    subViewsBuilder()
    constraintsBuilder()
    setupGestures()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let photo = self.photo else {
      photoImageView.image = UIImage(named: "no-image-found.jpeg")
      return
    }
    photoImageView.image = photo
  }

  /// # Only lays out the `view's siblings`
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    applyLayers()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("view will disappear")
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let createdNewPhoto = self.createdNewPhoto {
      photoPickerDelegate?.didCreateNewPhoto(photo: createdNewPhoto)
    }
    print("\(self) view did disappear")
  }

  deinit {
    print("deinit \(self)")
  }

  private func applyLayers() {
    if saveButtonLayer == nil {
      /// # Force to update the layout inmediatly
      saveButton.superview?.layoutIfNeeded()
      saveButtonLayer = saveButton.addShadowAndCorners(fillColor: UIColor.systemBlue.cgColor, cornerRadius: 15, shadowColor: UIColor.systemBlue.cgColor, shadowOffset: .zero, shadowOpacity: 0.8, shadowRadius: 3.0)
      saveButton.layer.insertSublayer(saveButtonLayer, at: 0)
    }
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
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

      fullStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      fullStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
      fullStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      photoImageView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.6, constant: -10),
      stackView.heightAnchor.constraint(equalTo: fullStackView.heightAnchor, multiplier: 0.4),

      titleLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
      titleFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.2),

      descriptionLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
      descriptionFieldView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6, constant: -15),

      saveButtonContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      saveButtonContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      saveButtonContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      saveButtonContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.09),

      saveButton.leadingAnchor.constraint(equalTo: saveButtonContainerView.leadingAnchor),
      saveButton.trailingAnchor.constraint(equalTo: saveButtonContainerView.trailingAnchor),
      saveButton.topAnchor.constraint(equalTo: saveButtonContainerView.topAnchor, constant: 5),
      saveButton.bottomAnchor.constraint(equalTo: saveButtonContainerView.bottomAnchor, constant: -25),
    ])
  }
}

extension PhotoFormVC {
  @objc private func saveNewPhoto() {
    guard let title = titleFieldView.text else { return }
    guard let description = descriptionFieldView.text else { return }
    guard let photo = photo else { return }
    guard !title.isEmpty, !description.isEmpty else { return }
    let imagePathName = UUID().uuidString
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let imagePath = documentsPath.appendingPathComponent(imagePathName)

    let newPhoto = Photo(name: title.capitalizingFirstLetter(), caption: description, url: imagePath.path)

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let strongSelf = self else { return }
      if let jpegData = photo.jpegData(compressionQuality: 0.70) {
        try? jpegData.write(to: imagePath)
      }
      guard let library = strongSelf.photoPickerDataSource?.getLibrary() else { return }
      library.photos.insert(newPhoto, at: 0)
      strongSelf.createdNewPhoto = newPhoto
    }
    navigationController?.popViewController(animated: true)
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

extension PhotoFormVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    descriptionFieldView.becomeFirstResponder()
    return true
  }
}

extension PhotoFormVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    var point = textView.frame.origin
    navigationItem.largeTitleDisplayMode = .never
    print("text view: \(textView)")
    print("point: \(point)")
    point.y = point.y - 100
    scrollView.setContentOffset(point, animated: true)
    print("new point: \(point)")
    print("editing description")
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    var point = textView.frame.origin
    print("text view: \(textView)")
    print("point: \(point)")
    point.y = point.y - 200
    scrollView.setContentOffset(point, animated: true)
    print("end editing description")
  }
}
