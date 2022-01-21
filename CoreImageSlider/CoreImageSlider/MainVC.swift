//
//  ViewController.swift
//  CoreImageSlider
//
//  Created by Leonardo  on 19/01/22.
//

import CoreImage
import UIKit

class MainVC: UIViewController {
  private var picker: PHPicker?
  var context: CIContext!
  var currentFilter: CIFilter!

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
    image.image = UIImage(systemName: "photo")
    image.tintColor = UIColor.systemBlue.withAlphaComponent(0.2)
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
    slider.minimumValue = 0.1
    slider.maximumValue = 1
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
    btn.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
    return btn
  }()

  private let saveBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Save", for: .normal)
    btn.setTitleColor(UIColor.systemBlue, for: .normal)
    btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
    btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    btn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemGray6
    configNavbar()
    setupSubViews()
    setupConstraints()
    configCI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if picker != nil { picker = nil }
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
    applyProcessing()
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
    // Deallocating PHPicker after picture has been selected
    picker = nil
    currentPicture = picture
    intensitySlider.value = 0
    print("picture: \(picture)")
    guard let currentPicture = self.currentPicture else { return }
    let beginImage = CIImage(image: currentPicture)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
  }
}

extension MainVC {
  private func configCI() {
    // Creating context is computational expensive
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone") // initial filter
  }

  private func applyProcessing() {
    guard let ciImage = currentFilter.outputImage else { return }
    let inputKeys = currentFilter.inputKeys // all available filter input parameters
    // Filters support different settings, not all of them support Intensity
    if inputKeys.contains(kCIInputIntensityKey) {
      currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
    }
    if inputKeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
    }
    if inputKeys.contains(kCIInputScaleKey) {
      currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
    }
    if inputKeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(CIVector(x: currentPicture!.size.width / 2, y: currentPicture!.size.height / 2), forKey: kCIInputCenterKey)
    }

    if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
      let processedImage = UIImage(cgImage: cgImage)
      imageView.image = processedImage
    }
  }

  @objc private func changeFilter(_ sender: UIButton) {
    let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    // iPad support
    if let popoverController = ac.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    present(ac, animated: true, completion: { [weak self] in
      self?.intensitySlider.value = 0.1
    })
  }

  private func setFilter(action: UIAlertAction) {
    // Make sure there is a valid picture
    guard let currentPicture = self.currentPicture else { return }
    // Read alert action's title
    guard let actionTitle = action.title else { return }
    // Set new title
    currentFilter = CIFilter(name: actionTitle)

    // Set UIImage to CIImage
    let ciImage = CIImage(image: currentPicture)
    currentFilter.setValue(ciImage, forKey: kCIInputImageKey) // key to use the input image
    applyProcessing()
  }

  @objc
  private func saveImage() {
    guard let picture = imageView.image else { return }
    // Save image to photos album
    UIImageWriteToSavedPhotosAlbum(picture, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }

  @objc
  private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    var alertTitle = "Success"
    var alertMessage = "Edited picture saved to library"
    if let error = error {
      alertTitle = "Error"
      alertMessage = "\(error.localizedDescription)"
    }
    let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
    present(ac, animated: true, completion: nil)
  }
}
