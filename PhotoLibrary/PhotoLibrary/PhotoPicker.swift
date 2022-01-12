//
//  ImagePickerVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 9/01/22.
//

import PhotosUI
import UIKit

class PhotoPicker: UIViewController, PHPickerViewControllerDelegate {
  weak var photoPickerDelegate: PhotoPickerDelegate?

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
        self?.photoPickerDelegate?.didSelectPhoto(image: image)
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

  func setupPicker(_ presentingVC: UIViewController) {
    let vc = PHPickerViewController(configuration: configurePicker())
    vc.delegate = self
    vc.modalPresentationStyle = .fullScreen
    presentingVC.present(vc, animated: true, completion: nil)
  }
}
