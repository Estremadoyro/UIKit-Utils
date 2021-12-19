//
//  AnchorsViewController.swift
//  AutoLayout-Programmatically
//
//  Created by Leonardo  on 18/12/21.
//

import UIKit

extension UIViewController {
  var VIEW_HEIGHT: CGFloat { view.frame.size.height }
  var VIEW_WIDTH: CGFloat { view.frame.size.width }
}

/// # ``Anchors:`` Width, height, top, bottom, leading, trailing, left, right, centerX, centerY
/// # SAME: `left & leading`
/// # SAME: `right & trailing`
/// # *Unless in hebrew & arabic (read right to left)*
class AnchorsViewController: UIViewController {
  // MARK: Properties

  var mangas: [(title: String, color: UIColor)] = [
    ("Dr. Stone", UIColor.systemGreen),
    ("The Promised Neverland", UIColor.systemPurple),
    ("Spy x Family", UIColor.systemPink),
    ("One Punch Man", UIColor.systemYellow),
    ("Dragon Ball", UIColor.systemOrange)
  ]
  var mangaLabels = [UILabel]()

  // MARK: LOGIC

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
      /// # ``Width anchor: It can take`equalToConstant`
//      label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
      /// # ``Pins the label to the `edges of its parent``
//      label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//      label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      /// # ``Activates constraints for safeArea when the devide is in landscape mode (Horizontal)``
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      /// # Height anchor
//      label.heightAnchor.constraint(equalToConstant: (VIEW_HEIGHT / 5) - 10).isActive = true
//      label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: 10).isActive = true
      /// # `view.heightAnchor` is the ``VIEW HEIGHT``
      label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
      /// # Make label `top anchor` equal to the `previous bottom anchor `
      /// # So during the `1st. iteration`, `previousLabel` will be `nil`
      if let previousLabel = previousLabel {
        /// # Starting from the `2nd label`, the `x1 label top anchor` will be equal to the `x0 label bottom anchor`
        /// # `constant: 10` -> gives a value to `.topAnchor` as the `.bottomAnchor` value is actually `0`, as it has not been defined
        /// # Works like a `anchor in between labels`
        label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
      } else {
        /// # First label, if `constant: 0` then there is `no anchor`
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      }
      if let lastLabel = mangaLabels.last {
        /// # Overlaps `the bottom view` with the one `on top of it`
        lastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = false
      }
      /// # The `previous` label will be saved as the one from the `1st. iteration` and update each time
      previousLabel = label
    }
  }
}
