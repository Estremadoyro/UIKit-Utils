//
//  DetailVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 19/01/22.
//

import UIKit

class DetailVC: UIViewController {
  var photo: Photo
  lazy var photoView = UIImageView()

  init(photo: Photo) {
    self.photo = photo
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    setupNavBar()
    setupViews()
    setupConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = photo.name
  }

  deinit {
    print("deinit \(self)")
  }
}

extension DetailVC {
  private func setupViews() {
    configurePhotoView()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      photoView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

extension DetailVC {
  private func configurePhotoView() {
    photoView.translatesAutoresizingMaskIntoConstraints = false
    photoView.image = UIImage(contentsOfFile: photo.url)
    photoView.contentMode = .scaleAspectFill
    photoView.clipsToBounds = true
    view.addSubview(photoView)
  }
}

extension DetailVC {
  private func setupNavBar() {
    navigationController?.navigationBar.prefersLargeTitles = false
    let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(sharePhoto))
    navigationItem.rightBarButtonItems = [shareBtn]
  }

  @objc private func sharePhoto() {
    let photo = UIImage(contentsOfFile: self.photo.url) ?? UIImage(named: "no-image-found.jpeg")
    let activityVC = UIActivityViewController(activityItems: [photo!], applicationActivities: nil)
    // Prevents from crashing on iPad
    popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

//    activityVC.isModalInPresentation = true
    present(activityVC, animated: true, completion: nil)
  }
}
