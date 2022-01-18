//
//  DetailViewController.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 10/12/21.
//

import UIKit

/// # NavigationView's NavigationLinks are `destroyed` after shown

class DetailViewController: UIViewController {
  var imageViwq: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.clipsToBounds = true
    image.contentMode = .scaleToFill
    return image
  }()

  /// # It has to be an `optional`, as it `may or may not` get an init value
  var selectedImage: String?
  var picturesList: [String]?
  var currentPicture: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imageViwq)
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
    if let imageToLoad = selectedImage {
      imageViwq.image = UIImage(named: imageToLoad)
    }

    NSLayoutConstraint.activate([
      imageViwq.widthAnchor.constraint(equalTo: view.widthAnchor),
      imageViwq.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
      imageViwq.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      imageViwq.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationController?.hidesBarsOnTap = false
  }

  @objc private func shareApp() {
    let appDescription: String = "Best app in the whole spiderverse"
    /// # It's ok to `force unwrap (!)`, due to this being `static values` which are from the `AppBundle`, meaning it `CAN'T` fail to a `logic error` but to a `human error`
    let appShareIcon = UIImage(named: "senku.jpeg")! /// # Not entirely necessary
    guard let appLink = NSURL(string: "https://www.apple.com") else {
      print("App website down")
      return
    }
    let vc = UIActivityViewController(activityItems: [appDescription, appLink, appShareIcon], applicationActivities: nil)
    /// # Prevents from `crashing in iPad`
    popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    /// # Pre-configuring activity items
    vc.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
    vc.isModalInPresentation = true
    present(vc, animated: true, completion: nil)
  }
  deinit {
    print("deinited \(self)")
  }
}
