//
//  ViewController.swift
//  ProgrammaticallyUIMarginsAlignment
//
//  Created by Leonardo  on 22/12/21.
//

import UIKit

class ViewController: UIViewController {
  var cluesLabel: UILabel!
  var answersLabel: UILabel!
  var currentAnswer: UITextField!
  var scoreLabel: UILabel!
  var letterButtons = [UIButton]()

  /// # To make the whole view `programmatically`
  override func loadView() {
    let submitButton = submitButtonView()
    let clearButton = clearButtonView()
    let buttonsContainer = buttonsContainerView()
    /// # Assigning the view to `UIView`
    view = UIView()
    view.backgroundColor = UIColor.white
    viewBuilder(submitButtonView: submitButton, clearButtonView: clearButton, buttonsContainerView: buttonsContainer)
    constraintsBuilder(submitButtonView: submitButton, clearButtonView: clearButton, buttonsConatinerView: buttonsContainer)
  }

  private func viewBuilder(submitButtonView: UIButton, clearButtonView: UIButton, buttonsContainerView: UIView) {
    view.addSubview(scoreLabelView())
    view.addSubview(cluesLabelView())
    view.addSubview(answersLabelView())
    view.addSubview(currentAnswerView())
    view.addSubview(submitButtonView)
    view.addSubview(clearButtonView)
    view.addSubview(buttonsContainerView)
  }

  private func constraintsBuilder(submitButtonView submitButton: UIButton, clearButtonView clearButton: UIButton, buttonsConatinerView buttonsContainer: UIView) {
    /// # `Activate` multiple `constraints` at once
    /// # `Anchors` -> Binds a view to a positions (``Ancla``)
    NSLayoutConstraint.activate([
      /// # `layoutMarginGuide` -> The default margins in the view (Inside the `safeAreaGuide`
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      /// # Pin the `cluesLabel` to the `bottom` of the `scoreLabel`
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      /// # Adding `100` constant in order to inset it (Margin = `layoutMargin + 100`)
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      /// # Setting up the `width` to be `60%` of the `inset layourMargin view`
      /// # `constant: -100` is to make the `layourMarginsGuideWidth` consider the `inset` view leading anchor
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
      /// # Pin the `answersLabel` to the `bottom` of the `scoreLabel`
      answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      /// # `constrant: -100` is negative because the X axis goes from left to right, so in order to `inset` a `trailing margin` the values has to be negative
      answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      /// # Will take `40%` of the parent view, `constant: 100` make the
      answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      /// # Make both `answersLabel` and `cluesLabel` have the `same height`
      answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      /// # Center the TextField in the middle of the `whole view`, not counting the `layourMarginGuide` or any inset
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      /// # Make it `50%` of the `view` size
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      /// # Place the `top` on the `bottom` of the `cluesLabel` and add `20`
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
      /// # Place `submitbutton` right underneath the `currentAnswer` view
      submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      /// # Place `submitButton` in the `centerX` of the `view`, with `x: -100`
      submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submitButton.heightAnchor.constraint(equalToConstant: 44),
      /// # Place `clearButton` in the `centerX` of the `view`, with `x: 100`
      clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      /// # Align to the `submitButton` same position, so when `submitButton` ``topAnchor`` changes, this one does aswell
      clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
      clearButton.heightAnchor.constraint(equalToConstant: 44),
      buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
      buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
      buttonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
      /// # This cosntraint, makes the `scoreLabel` ``stretch`` vertically, in order for the `buttonContainer` to tbe `-20 points` away from the `layourMarginGuide.bottomAnchor`
      buttonsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
    ])
  }

  private func buttonsLetterView(row: Int, column: Int, buttonsContainer: UIView) {
    let width: Double = 150.0
    let height: Double = 80.0
    let letterButton = UIButton(type: .system)
    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
    letterButton.setTitle("WWW", for: .normal)
    letterButton.frame = CGRect(x: Double(column) * width, y: Double(row) * height, width: width, height: height)
    buttonsContainer.addSubview(letterButton)
    letterButtons.append(letterButton)
  }

  private func buttonsContainerView() -> UIView {
    let buttonsContainer = UIView()
    buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
    buttonsContainer.backgroundColor = UIColor.systemGreen
    /// # Generate letter buttons
    for row in 0..<4 {
      for col in 0..<5 {
        buttonsLetterView(row: row, column: col, buttonsContainer: buttonsContainer)
      }
    }
    return buttonsContainer
  }

  private func submitButtonView() -> UIButton {
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    return submit
  }

  private func clearButtonView() -> UIButton {
    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    return clear
  }

  private func currentAnswerView() -> UITextField {
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tap letters to guess"
    currentAnswer.textAlignment = NSTextAlignment.center
    currentAnswer.font = UIFont.systemFont(ofSize: 44)
    /// # User can't enter text
    currentAnswer.isUserInteractionEnabled = false
    return currentAnswer
  }

  private func cluesLabelView() -> UILabel {
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.font = UIFont.systemFont(ofSize: 24)
    cluesLabel.text = "CLUES"
    /// # Unlimited lines to fit the test
    cluesLabel.numberOfLines = 0
    cluesLabel.textAlignment = NSTextAlignment.left
    cluesLabel.backgroundColor = UIColor.systemBlue
    /// # Make the view `first in line` to be stretched more than its `intrinsic content size` (more than needed)
    /// # `contentHuggingPriority` -> Stretching resistance, to make the view larger than its `instric content size`
    /// # Default `250` (1 Its ok to stretch, 999: Don't try to stretch)
    /// # `contentCompressionResistancePriority` -> Compression resistance, to make a view smaller than its `intrinsic content size`
    /// # Default `750` (1 Its ok to compress, 999: Don't try to compress)
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    return cluesLabel
  }

  private func answersLabelView() -> UILabel {
    answersLabel = UILabel()
    answersLabel.translatesAutoresizingMaskIntoConstraints = false
    answersLabel.font = UIFont.systemFont(ofSize: 24)
    answersLabel.text = "ANSWERS"
    answersLabel.numberOfLines = 0
    answersLabel.textAlignment = NSTextAlignment.right
    answersLabel.backgroundColor = UIColor.systemPink
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    return answersLabel
  }

  private func scoreLabelView() -> UILabel {
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = NSTextAlignment.right
    scoreLabel.text = "Score: 0"
    scoreLabel.backgroundColor = UIColor.systemYellow
    return scoreLabel
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
