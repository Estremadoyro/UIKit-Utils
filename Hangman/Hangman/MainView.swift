//
//  MainView.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

extension UIStackView {
  func addArrangedSubViews(_ views: UIView...) {
    views.forEach { view in addArrangedSubview(view) }
  }
}

class MainView: UIView {
  var wordToGuess: String?
  private let wordToGuessContainer = UITextField()

  /// # Override `UIView` initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.black
    viewBuilder()
    constraintsBuilder()
  }

  /// # `*`           -> Applied to all platforms
  /// # `unavailable` -> Causes the API to generate a `compiler error when used`
  @available(*, unavailable)
  required init?(coder: NSCoder) { /// # Needed for `Interface Builder`, but not programmatically
    fatalError("init(coder:) has not been implemented")
  }

  private func viewBuilder() {
    addSubview(wordToGuessView())
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
    ])
  }

  private func wordToGuessView() -> UITextField {
    wordToGuessContainer.textColor = UIColor.white
    return wordToGuessContainer
  }
}
