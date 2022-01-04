//
//  TestViewController.swift
//  UICollectionView
//
//  Created by Leonardo  on 3/01/22.
//

import UIKit

class TestViewController: UIViewController {
  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Go to checkout"
    label.font = UIFont.systemFont(ofSize: 22)
    label.textAlignment = .center
//    label.textColor = UIColor.white
//    label.backgroundColor = UIColor.systemGreen
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//      label.topAnchor.constraint(equalTo: view.topAnchor),
//      label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      label.widthAnchor.constraint(equalToConstant: 300),
      label.heightAnchor.constraint(equalToConstant: 150),
//      label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
//      label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
    ])
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    /// # `true` makes subviews to be clipped to the reciever,
//    /// # `false`, no clipping, so `shadows work`, but `corner radius doesn't`
//    ///  # makes `maskToBounds` ``false``
//    label.clipsToBounds = true
//    print("clipsToBounds: \(label.clipsToBounds)")
//    /// # `true` implicit `clipping`, enables `corner radius`
//    /// # `false` makes `shadow work` but `not corner radius`
//    /// # When `true` it sets `clipsToBounds` ``true
//    label.layer.masksToBounds = false
//    print("clipsToBounds: \(label.clipsToBounds)")
//    label.layer.shadowRadius = 7
//    label.layer.shadowOpacity = 1
//    label.layer.shadowOffset = .zero
//    label.layer.shadowColor = UIColor.systemPink.cgColor
//    label.layer.cornerRadius = 15
//    print("masksToBounds: \(label.layer.masksToBounds)")
    let shadowLayer = CAShapeLayer()

    shadowLayer.path = UIBezierPath(roundedRect: label.bounds, cornerRadius: 15).cgPath
    shadowLayer.fillColor = UIColor.systemGreen.cgColor

    shadowLayer.shadowColor = UIColor.systemGreen.cgColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    shadowLayer.shadowOpacity = 1
    shadowLayer.shadowRadius = 8
    view.layer.insertSublayer(label.layer, at: 0)
    label.layer.insertSublayer(shadowLayer, at: 1)
  }
}
