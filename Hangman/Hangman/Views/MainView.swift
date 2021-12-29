//
//  MainView.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

class MainView: UIView {
  var mainViewController = MainViewController()
  var wordToGuess: String = "" {
    didSet {
      print("word set")
    }
  }

  var wordPlaceholder: String = "?" {
    didSet {
      wordToGuessInputField.text = mainViewController.getPlaceholderString(currentWord: wordToGuess)
    }
  }

  var wordToGuessLetters: Int = 0 {
    didSet {
      wordLettersCountLabel.text = "# Letters: \(wordToGuessLetters)"
    }
  }

  private let wordToGuessInputField = UITextField()
  private let wordLettersCountLabel = UILabel()
  let alphabetButtonsContainer = UIView()
  private let alphabetButton = UIButton(type: .system)
  /// # Override `UIView` initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.black
    setInitialValues()
    viewBuilder()
    constraintsBuilder()
  }

  private func setInitialValues() {
    mainViewController.readWordsFile()
    wordToGuess = mainViewController.currentWord
    wordPlaceholder = mainViewController.getPlaceholderString(currentWord: wordToGuess)
    wordToGuessLetters = mainViewController.setCurrentWordLetters(currentWord: wordToGuess)
  }

  /// # `*`           -> Applied to all platforms
  /// # `unavailable` -> Causes the API to generate a `compiler error when used`
  /// # Removes the need of using it in subclasses
  @available(*, unavailable)
  required init?(coder: NSCoder) { /// # Needed for `Interface Builder`, but not programmatically
    fatalError("init(coder:) has not been implemented")
  }

  private func viewBuilder() {
    addSubview(wordLettersCountLabelView())
    addSubview(wordToGuessView())
    addSubview(alphabetButtonsContainerView())
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      wordLettersCountLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),
      wordLettersCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      wordLettersCountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      wordToGuessInputField.topAnchor.constraint(equalTo: wordLettersCountLabel.bottomAnchor),
      wordToGuessInputField.leadingAnchor.constraint(equalTo: wordLettersCountLabel.leadingAnchor),
      wordToGuessInputField.widthAnchor.constraint(equalTo: wordLettersCountLabel.widthAnchor),
      alphabetButtonsContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      alphabetButtonsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
      alphabetButtonsContainer.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),
      alphabetButtonsContainer.topAnchor.constraint(equalTo: wordToGuessInputField.bottomAnchor, constant: 10),
    ])
  }

  private func wordToGuessView() -> UITextField {
    wordToGuessInputField.translatesAutoresizingMaskIntoConstraints = false
    wordToGuessInputField.textColor = UIColor.white
    wordToGuessInputField.text = wordPlaceholder
    wordToGuessInputField.textAlignment = .center
    wordToGuessInputField.font = UIFont.systemFont(ofSize: 44)
    wordToGuessInputField.isUserInteractionEnabled = false
    wordToGuessInputField.layer.borderWidth = 1
    wordToGuessInputField.layer.borderColor = UIColor.white.cgColor
    return wordToGuessInputField
  }

  private func wordLettersCountLabelView() -> UILabel {
    wordLettersCountLabel.translatesAutoresizingMaskIntoConstraints = false
    wordLettersCountLabel.text = "# Letters: \(wordToGuessLetters)"
    wordLettersCountLabel.textColor = UIColor.white
    wordLettersCountLabel.font = UIFont.systemFont(ofSize: 30)
    wordLettersCountLabel.textAlignment = .left
    return wordLettersCountLabel
  }

  func alphabetButtonsContainerView() -> UIView {
    alphabetButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
    alphabetButtonsContainer.layer.borderWidth = 1
    alphabetButtonsContainer.layer.borderColor = UIColor.white.cgColor
    alphabetButtonsContainer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    return alphabetButtonsContainer
  }

  func generateAlphabetButtons() {
    let height = alphabetButtonsContainer.bounds.height / 7
    let width = alphabetButtonsContainer.bounds.width / 4
    var counter = 0
    let alphabet = Alphabet.letters
    for row in 0..<6 {
      for column in 0..<4 {
        let btnFrame = CGRect(x: width * Double(column), y: height * Double(row), width: width, height: height)
        letterButtonView(letter: String(alphabet[counter]), frame: btnFrame)
        counter += 1
      }
    }
    /// # Adding last row
    let lastBtns = ["Hint", "Y", "Z", "Next"]
    for column in 0..<4 {
      let btnFrame = CGRect(x: width * Double(column), y: height * 6, width: width, height: height)
      letterButtonView(letter: lastBtns[column], frame: btnFrame)
    }
  }

  func letterButtonView(letter: String, frame: CGRect) {
    let letterButton = UIButton(type: .system)
    letterButton.frame = frame
    letterButton.translatesAutoresizingMaskIntoConstraints = true
    letterButton.setTitle(letter, for: .normal)
    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 44)
    letterButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
    letterButton.layer.borderColor = UIColor.white.cgColor
    letterButton.layer.borderWidth = 1
    letterButton.addTarget(mainViewController, action: #selector(mainViewController.buttonPressed), for: .touchUpInside)
    alphabetButtonsContainer.addSubview(letterButton)
  }
}
