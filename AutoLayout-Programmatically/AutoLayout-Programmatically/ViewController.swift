//
//  ViewController.swift
//  AutoLayout-Programmatically
//
//  Created by Leonardo  on 18/12/21.
//

import UIKit

class ViewController: UIViewController {
  var colors = [UIColor.red, UIColor.green, UIColor.cyan, UIColor.purple, UIColor.blue]
  var mangas = ["Spy x Family", "Dr. Stone", "One Punch Man", "The Promised Neverland", "Komi Can't Communicate"]
  var viewsDictionary = [String: UILabel]()
  override func viewDidLoad() {
    super.viewDidLoad()
    for i in 0 ..< 5 {
      /// # Text labels
      let label = UILabel()
      /// # Don't use `AutoResizingMask`, create own `custom constraints`
      label.translatesAutoresizingMaskIntoConstraints = false
      label.backgroundColor = colors[i]
      label.text = mangas[i]
      label.textColor = UIColor.white
      /// # Make the `label container` fit the `text length`
      label.sizeToFit()
      /// # Append elements to `viewsDictionary`
      viewsDictionary["label\(i + 1)"] = label
      view.addSubview(label)
    }
    /// # ``Auto Layout Visual Format Language`` (VFL)
    /// Draws the layout with a series of symbols
    /// # 1. Create dictionary with `all the labels`
    /// # 2. Add constraints
    for label in viewsDictionary.keys {
      /// # `H` means adding an `horizontal layout`
      /// # `|` means expand to `edge of the view`
      /// # `[]` are the `edges of the view`
      /// # `[label]` add `label` view here
      /// # `views`: Dictionary which containts the `names of the VFL`, when it sees [`label`] it looks in the dictionary for the`label` key
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
      /// # However, subViews are still `overlapping`, must to add `vertical layout constraints`
      /// # `V` means adding a `vertical layout`
      /// # `-` means space by 10 points by default
      /// # It's missing `| at the end`, meaning it's not forcing the label to stretch all the way to the edge of the view
      /// # Multiply constraints will be created over the `VFL`, as all the labels are inside the `[]`
      /// # `-(>=10)-` adding constraints to the `last label`, meaning `10 points from the bottom` so some labes don't go past it. ``When specifiing the size of the space``
      /// # `-|` is the `space from the bottom` (`|`)
      /// # `(==88)` means `88 points` of height
      let metrics = ["labelHeight": 88]
      /// # `metrics` let you parametrize the values of the `VFL`
      /// # The `bottom space size >=10 and height (88)` will crash the app, when rotated, as it `can't` satisfy the constraints, meaning there ``is not enough screen space``
      /// # Making the `priority` less than `1000` (999) makes it very important, but optional, and tells `AutoLayout` to find the best possible solution if `all the constraints can't be met`
      /// # But `AutoLayout` might `shrink` some labels and make others `bigger`, so ``make all tables have the same height at all times``
      /// # `(labelHeight@999)` means, ok use the `given height (88pts)`, but if there is `not enought space` then change the `size at will` but make sure all of them are the `same height`, hence all the labels have `(label1)` as their height
      view.addConstraints(NSLayoutConstraint.constraints(
        withVisualFormat:
        "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=0-|",
        options: [],
        metrics: metrics,
        views: viewsDictionary)
      )
    }
  }
}
