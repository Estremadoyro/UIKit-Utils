//
//  ImagePickerVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 9/01/22.
//

import PhotosUI
import UIKit

class PhotoPicker: PHPickerViewControllerDelegate {
  weak var photoPickerDelegate: PhotoPickerDelegate?
  lazy var photoPickerVC: PHPickerViewController = {
    let photoPickerVC = PHPickerViewController(configuration: configurePicker())
    photoPickerVC.delegate = self
    photoPickerVC.modalPresentationStyle = .fullScreen
    return photoPickerVC
  }()

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)
    // Get first item
    let itemProvider = results.first?.itemProvider
    // Access the UIImage representation of the result
    if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
        guard let image = reading as? UIImage, error == nil else {
          return
        }
        DispatchQueue.main.async {
          self?.photoPickerDelegate?.didSelectPhoto(image: image)
        }
      }
    }
  }

  private func configurePicker() -> PHPickerConfiguration {
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.selectionLimit = 1
    config.filter = .images
    if #available(iOS 15, *) {
      config.selection = .ordered
    }
    return config
  }

  deinit {
    print("deinit \(self)")
  }
}
