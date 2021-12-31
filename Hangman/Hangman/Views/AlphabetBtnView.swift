//
//  AlphabetBtnView.swift
//  Hangman
//
//  Created by Leonardo  on 29/12/21.
//

import UIKit

/// # ``Keep this as a reminder``
/// # Not all the default `init()` have to be overriden
/// # `init(frame: CGRect)` was never necessary, just `super.init(frame: CGRect)`
class AlphabetBtnView: UIButton {
  let mainViewController = MainViewController()
  var letter: String

  required init(frame: CGRect, letter: String) {
    self.letter = letter
    super.init(frame: frame)
    btnSettings()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func btnSettings() {
    translatesAutoresizingMaskIntoConstraints = true
    setTitle(letter, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 44)
    setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1
//    addTarget(mainViewController, action: #selector(mainViewController.buttonPressed), for: .touchUpInside)
  }
}
