//
//  PhotoPickerVC.swift
//  Project25-P2P
//
//  Created by Leonardo  on 15/03/22.
//

import PhotosUI

final class PhotoPicker {
  weak var photoPickerDelegate: PhotoPickerDelegate?
  var photoPickerVC: PHPickerViewController?

  init() {
    configurePhotoPickerController()
  }

  deinit { print("\(self) deinited") }
}

extension PhotoPicker {
  private func configurePhotoPickerController() {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.selectionLimit = 1
    configuration.filter = .images

    photoPickerVC = PHPickerViewController(configuration: configuration)
    photoPickerVC?.delegate = self
  }
}

extension PhotoPicker: PHPickerViewControllerDelegate {
  // Runs in Background Thread by default
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)
    // Retrieve first & only item selected
    let itemProvider = results.first?.itemProvider
    // Access the UIImage contained in the itemProvider
    if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      // Load the object
      itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] reading, error in
        guard let image = reading as? UIImage, error == nil else { return }
        DispatchQueue.main.async {
          self.photoPickerDelegate?.didSelectPhoto(photo: image)
        }
      }
    }
  }
}
