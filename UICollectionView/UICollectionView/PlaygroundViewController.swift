//
//  ViewController.swift
//  UICollectionView
//
//  Created by Leonardo  on 1/01/22.
//

import UIKit

class PlaygroundViewController: UIViewController {
  lazy var label: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: view.frame.size.height / 2 - (view.frame.size.height / 10) / 2, width: view.frame.size.width, height: view.frame.size.height / 10))
    label.translatesAutoresizingMaskIntoConstraints = true
    label.text = "Mangakasa"
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 44)
    label.layer.borderColor = UIColor.white.cgColor
    label.layer.borderWidth = 2
    print("label position: \(view.frame.height / 2)")
    return label
  }()

  lazy var midLine: UILabel = {
    let line = UILabel(frame: CGRect(x: 0, y: view.frame.size.height / 2, width: view.frame.size.width, height: 2))
    line.backgroundColor = UIColor.systemBlue
    return line
  }()

  lazy var topLine: UILabel = {
    let line = UILabel(frame: CGRect(x: 0, y: (view.frame.size.height / 2) - (view.frame.size.height / 10) / 2, width: view.frame.size.width, height: 2))
    line.backgroundColor = UIColor.systemBlue
    return line
  }()

  lazy var bottomLine: UILabel = {
    let line = UILabel(frame: CGRect(x: 0, y: (view.frame.size.height / 2) + (view.frame.size.height / 10) / 2, width: view.frame.size.width, height: 2))
    line.backgroundColor = UIColor.systemBlue
    return line
  }()

  override func loadView() {
    super.loadView()
    print(view.frame)
//    view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    view.addSubview(label)
    view.addSubview(topLine)
    view.addSubview(midLine)
    view.addSubview(bottomLine)
//    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemPink
  }
}
