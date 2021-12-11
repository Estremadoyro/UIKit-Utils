//
//  DetailViewController.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 10/12/21.
//

import UIKit

/// # NavigationView's NavigationLinks are `destroyed` after shown

class DetailViewController: UIViewController {
  /// # `@IBOutlet` indicates a connection of a `View` from `StoryBoard` into code
  @IBOutlet var imageViwq: UIImageView!

  /// # It has to be an `optional`, as it `may or may not` get an init value
  var selectedImage: String?
  var picturesList: [String]?
  var currentPicture: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    /// # Since both `title` and `selectedImage` are `optionals` there is no need for unwrapping
    /// # But if set to something else, then unwrapping is needed
    if let listOfPictures = picturesList {
      if let picture = currentPicture {
        title = "Picture \(picture) of \(listOfPictures.count)"
      } else {
        title = "Picture X of \(listOfPictures.count)"
      }
    }
    /// # This will inherit the settings from the `NavigationController`
    navigationItem.largeTitleDisplayMode = .never
    if let imageToLoad = selectedImage {
      imageViwq.image = UIImage(named: imageToLoad)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationController?.hidesBarsOnTap = false
  }
}
