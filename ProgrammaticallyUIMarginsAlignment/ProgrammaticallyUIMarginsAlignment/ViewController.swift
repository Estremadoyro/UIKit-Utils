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
  /// # Buttons current selected
  var activatedButtons = [UIButton]()
  /// # All possible solutions
  var solutions = [String]()
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }

  var hiddenButtons: Int = 0

  var level = 1

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

  private func loadLevel() {
    var levelClues = ""
    var levelNumberLetters = ""
    var buttonsLetters = [String]()

    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      /// # Read the `level` file
      if let levelFileURL = Bundle.main.url(forResource: "level\(self?.level ?? 1)", withExtension: "txt") {
        if let levelContents = try? String(contentsOf: levelFileURL) {
          /// # Make an array of all the file lines
          var lines = levelContents.components(separatedBy: "\n")
          lines.shuffle()
          // # Itereate through each level word-question
          for (index, line) in lines.enumerated() {
            /// # Split the line in 2 parts. One is `letter groups` (combined form the answer) and the other the `question clues`
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            /// # Make the entire clues a `single string` with line jump per question (`\n`)
            levelClues += "\(index + 1). \(clue) \n"
            /// # Removes `|` in order to get the full answer
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            levelNumberLetters += "\(solutionWord.count) letters\n"
            /// # Append answer to the list of `possible`solutions
            self?.solutions.append(solutionWord)
            /// # Split the `answer` into an array of `buttonLetters` by the `|`
            let buttonLetters = answer.components(separatedBy: "|")
            /// # Append the `answer letters array` to the list with all the `buttonLetters`
            buttonsLetters += buttonLetters
          }
        }
      }
      DispatchQueue.main.async { [weak self] in
        /// # Remove the empty lines from the strings
        self?.cluesLabel.text = levelClues.trimmingCharacters(in: .whitespacesAndNewlines)
        self?.answersLabel.text = levelNumberLetters.trimmingCharacters(in: .whitespacesAndNewlines)
        /// # Shuffle them so the `2-3 group of letters` that conform an answer are not next to each other
        buttonsLetters.shuffle()
        /// # Check if there are as `many groups of letters` as there are `UIButtons`
        if buttonsLetters.count == self?.letterButtons.count {
          guard let btns = self?.letterButtons else { return }
          for i in 0..<btns.count {
            self?.letterButtons[i].setTitle(buttonsLetters[i], for: .normal)
          }
        }
      }
    }
  }

  @objc func letterTapped(_ sender: UIButton) {
    /// # Check if butons has title
    guard let buttonTitle = sender.titleLabel?.text else { return }
    /// # Append to the `currentAnswer` text
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    /// # Active btn on tap
    activatedButtons.append(sender)
    /// # Hide btn after tapped
    sender.isHidden = true
  }

  @objc func submitTapped(_ sender: UIButton) {
    guard let answerText = currentAnswer.text else { return }
    guard !answerText.isEmpty else { return }
    /// # Check if the answer exists among the rest of answers
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      let buttonsUsed = activatedButtons.count
      hiddenButtons += buttonsUsed
      /// # If correct answer, remove activated buttons so far
      activatedButtons.removeAll()
      /// # Replace the `N letters` label with the `answer`
      var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
      splitAnswers?[solutionPosition] = answerText
      /// # Putting the `answersLabel` back together
      answersLabel.text = splitAnswers?.joined(separator: "\n")
      /// # Reset the `currentAnswer`
      currentAnswer.text = ""
      score += 1
      print("hiddenButtons: \(hiddenButtons)")
      print("letterButons.count: \(letterButtons.count)")
      if hiddenButtons == letterButtons.count {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
      return
    }
    incorrectAnswer()
  }

  private func incorrectAnswer() {
    let ac = UIAlertController(title: "Incorrect", message: "\(currentAnswer.text?.uppercased() ?? "WWW") doesn't exist", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
      guard let unwrappedSelf = self else { return }
      unwrappedSelf.score -= (unwrappedSelf.score > 0 ? 1 : 0)
    })
    present(ac, animated: true)
  }

  private func levelUp(action: UIAlertAction) {
    level += 1
    /// # Keep the length of array
    solutions.removeAll(keepingCapacity: true)
    /// # Load new level
    loadLevel()
    /// # Reset selected buttons
    for button in letterButtons {
      button.isHidden = false
    }
  }

  @objc func clearTapped(_ sender: UIButton) {
    currentAnswer.text? = ""
    /// # Reset active buttons
    for btn in activatedButtons {
      btn.isHidden = false
    }
    activatedButtons.removeAll()
  }

  private func buttonsLetterView(row: Int, column: Int, buttonsContainer: UIView) {
    let width: Double = 150
    let height: Double = 80
    let letterButton = UIButton(type: .system)
    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
    letterButton.setTitle("WWW", for: .normal)
    letterButton.frame = CGRect(x: Double(column) * width, y: Double(row) * height, width: width, height: height)
    letterButton.backgroundColor = UIColor.white
    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
    buttonsContainer.addSubview(letterButton)
    letterButtons.append(letterButton)
  }

  private func buttonsContainerView() -> UIView {
    let buttonsContainer = UIView()
    buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
    buttonsContainer.layer.borderColor = UIColor.gray.cgColor
    buttonsContainer.layer.borderWidth = 4
//    buttonsContainer.backgroundColor = UIColor.systemGreen
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
    /// # Adding an `action` for the button to execute when pressed
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    return submit
  }

  private func clearButtonView() -> UIButton {
    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
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
//    cluesLabel.backgroundColor = UIColor.systemBlue
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
//    answersLabel.backgroundColor = UIColor.systemPink
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    return answersLabel
  }

  private func scoreLabelView() -> UILabel {
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = NSTextAlignment.right
    scoreLabel.text = "Score: 0"
//    scoreLabel.backgroundColor = UIColor.systemYellow
    return scoreLabel
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadLevel()
  }
}
