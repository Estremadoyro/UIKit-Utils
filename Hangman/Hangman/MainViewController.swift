//
//  ViewController.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

class MainViewController: UIViewController {
  lazy var contentView = MainView()
  override func loadView() {
    view = contentView
  }
}
