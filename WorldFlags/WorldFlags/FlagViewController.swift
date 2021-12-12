//
//  FlagViewController.swift
//  WorldFlags
//
//  Created by Leonardo  on 12/12/21.
//

import UIKit

class FlagViewController: UIViewController {
  @IBOutlet var flagView: UIImageView!
  var flag: String?
  override func viewDidLoad() {
    super.viewDidLoad()
    loadFlagImage()
    navigationItemSettings()
    view.backgroundColor = UIColor.black
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }

  private func loadFlagImage() {
    if let flag = flag {
      title = flag.uppercased()
      flagView.image = UIImage(named: flag)
      flagView.clipsToBounds = true
    }
  }

  private func navigationItemSettings() {
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
  }

  @objc private func shareFlag() {
    /// # Get the `flagView` image, that has already been set
    guard let flagImage = flagView.image?.jpegData(compressionQuality: 0.8) else {
      print("No image found")
      return
    }
    guard let countryName = flag else {
      print("No contry name")
      return
    }
    let ac = UIActivityViewController(activityItems: [flagImage, countryName], applicationActivities: nil)
    present(ac, animated: true, completion: nil)
  }
}
