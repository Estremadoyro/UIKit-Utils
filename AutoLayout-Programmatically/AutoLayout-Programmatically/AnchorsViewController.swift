//
//  AnchorsViewController.swift
//  AutoLayout-Programmatically
//
//  Created by Leonardo  on 18/12/21.
//

import UIKit

/// # ``Anchors:`` Width, height, top, bottom, leading, trailing, left, right, centerX, centerY
/// # SAME: `left & leading`
/// # SAME: `right & trailing`
/// # *Unless in hebrew & arabic (read right to left)*
class AnchorsViewController: UIViewController {
  // MARK: Properties

  var mangas: [(title: String, color: UIColor)] = [
    ("Dr. Stone", UIColor.green),
    ("The Promised Neverland", UIColor.purple),
    ("Spy x Family", UIColor.systemPink)
  ]
  var mangaLabels = [UILabel]()

  override func viewDidLoad() {
    super.viewDidLoad()
    for manga in mangas {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = manga.title
      label.textColor = UIColor.white
      label.backgroundColor = manga.color
      label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
      label.sizeToFit()
      mangaLabels.append(label)
      view.addSubview(label)
    }
    var previousLabel: UILabel?
    for label in mangaLabels {
      print("manga label: \(label)")
      label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
      label.heightAnchor.constraint(equalToConstant: 100).isActive = true
      /// # Make label `top anchor` equal to the `previous bottom anchor `
      /// # So during the `1st. iteration`, `previousLabel` will be `nil`
      if let previousLabel = previousLabel {
        /// # Starting from the `2nd label`, the `x1 label top anchor` will be equal to the `x0 label bottom anchor`
        label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
      } else {
        /// # First label
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      }
      /// # The `previous` label will be saved as the one from the `1st. iteration` and update each time
      previousLabel = label
    }
  }
}
