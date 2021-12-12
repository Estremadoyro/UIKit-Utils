//
//  DetailViewController.swift
//  UIActivityUIBarButtonItem
//
//  Created by Leonardo  on 11/12/21.
//

import UIKit

class DetailViewController: UIViewController {
  /// # Connects something to `InterfaceBuilder` aka StoryBoard
  @IBOutlet var imageView: UIImageView!
  var selectedImage: String?
  var picturesList: [String]?
  var currentPicture: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItemSettings()
    setImageView()
  }

  private func setImageView() {
    if let selectedImage = selectedImage {
      imageView.image = UIImage(named: selectedImage)
    }
  }

  private func navigationItemSettings() {
    if let picturesList = picturesList {
      if let currentPicture = currentPicture {
        title = "Picture \(currentPicture) of \(picturesList.count)"
      } else {
        title = "Picture X of \(picturesList.count)"
      }
    }
    navigationItem.largeTitleDisplayMode = .never
    /// # Create a navigation-bar-item to share media
    /// # `barButtonSystemItem` -> Item icon
    /// # `target`              -> Where will the `action` method be located
    /// # `action`              -> Method to call after tapped (Must be an `@objc` method) `Requires a Selector type`
    /// # The `#selector` is a type in `@objc` that refers to the `name of an objc method`
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    /// # `@IBAction` is automatically implied by `Objective-C`
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }

  /// # `@objc` -> Expose this method to `Objective-C`
  @objc private func shareTapped() {
    /// # Unwrap the image set in the `UIViewCell`
    /// # `compressionQuality` goes from `0 to 1` (worst to best)
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found")
      return
    }
    /// # Create a `UIActivityViewController` to give option to share
    let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    /// # Set the `barButtonItem` which will anchor the `popover`
    /// # Whitout it, it won't run in iPad
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    /// # Show the `popover`
    present(vc, animated: true)
  }
}
