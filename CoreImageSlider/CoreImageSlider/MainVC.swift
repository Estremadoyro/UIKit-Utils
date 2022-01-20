//
//  ViewController.swift
//  CoreImageSlider
//
//  Created by Leonardo  on 19/01/22.
//

import UIKit

class MainVC: UIViewController {
  private var picker: PHPicker?
  var currentPicture: UIImage? {
    didSet {
      imageView.image = currentPicture
    }
  }

  private lazy var mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .equalCentering
    stack.spacing = 5
    stack.addArrangedSubview(imageContainerView)
    stack.addArrangedSubview(intensityStackView)
    stack.addArrangedSubview(buttonsStackView)
    return stack
  }()

  private lazy var imageContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.systemGray5
    view.addSubview(imageView)
    return view
  }()

  private let imageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.backgroundColor = UIColor.systemPink
    image.contentMode = .scaleAspectFit
    image.clipsToBounds = true
    return image
  }()

  private lazy var intensityStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.spacing = 10
    stack.addArrangedSubview(intensityLabel)
    stack.addArrangedSubview(intensitySlider)
    return stack
  }()

  private let intensityLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Intensity"
    label.textColor = UIColor.white
    label.font = UIFont.boldSystemFont(ofSize: 22)
    return label
  }()

  private let intensitySlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.minimumValue = 0
    slider.maximumValue = 100
    slider.isContinuous = true
    slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    return slider
  }()

  private lazy var buttonsStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fill
    stack.spacing = 10
    stack.addArrangedSubview(changeFilterBtn)
    stack.addArrangedSubview(saveBtn)
    return stack
  }()

  private let changeFilterBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Change Filter", for: .normal)
    btn.setTitleColor(UIColor.systemBlue, for: .normal)
    btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
    btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    return btn
  }()

  private let saveBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Save", for: .normal)
    btn.setTitleColor(UIColor.systemBlue, for: .normal)
    btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
    btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    return btn
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
    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    navigationItem.rightBarButtonItems = [addBtn]
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

      imageContainerView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.8, constant: -10),
      intensityStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.1),
      buttonsStackView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.1),

      changeFilterBtn.widthAnchor.constraint(equalTo: buttonsStackView.widthAnchor, multiplier: 0.5, constant: -5),
      saveBtn.widthAnchor.constraint(equalTo: buttonsStackView.widthAnchor, multiplier: 0.5, constant: -5),

      imageView.topAnchor.constraint(equalTo: imageContainerView.layoutMarginsGuide.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: imageContainerView.layoutMarginsGuide.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: imageContainerView.layoutMarginsGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: imageContainerView.layoutMarginsGuide.trailingAnchor),
    ])
  }
}

extension MainVC {
  @objc private func sliderValueDidChange(_ sender: UISlider!) {
    print("slider value: \(sender.value)")
  }
}

extension MainVC: PickerDelegate {
  @objc private func importPicture() {
    picker = PHPicker()
    picker?.pickerDelegate = self
    let pickerVC = picker?.photoPickerVC
    guard let pickerVC = pickerVC else { return }
    present(pickerVC, animated: true, completion: nil)
  }

  func didSelectPicture(picture: UIImage) {
    picker = nil
    print("picture: \(picture)")
    currentPicture = picture
    // Deallocating PHPicker after picture has been selected
  }
}
