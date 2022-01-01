//
//  ViewController.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

class MainViewController: UIViewController {
  var _lifes: Int = 7
  var _orientation: UIDeviceOrientation!
  var score: Int = 0
  var questions = [Question]()
  var currentQuestion: Question!
  var questionNumber = 1
  var currentPlaceholder: String = "?"
  var currentDiscoveredLetters = [String]()

  private lazy var mainView = MainView(frame: UIScreen.main.bounds)

  init() {
    super.init(nibName: nil, bundle: nil)
    readWordsFile()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    mainView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mainView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    mainView.generateAlphabetButtons()
    mainView.wordToGuessInputField.layer.cornerRadius = 15
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(alongsideTransition: { [weak self] _ in
      if UIDevice.current.orientation.isLandscape {
        self?._orientation = UIDeviceOrientation.landscapeRight
        print("landscape mode")
      } else {
        self?._orientation = UIDeviceOrientation.portrait
        print("portrait mode")
      }
    })
  }

  private func getPlaceholderString() -> String {
    return currentQuestion.word.reduce("") { placeholder, _ in
      placeholder + "?"
    }
  }

  private func readWordsFile() {
    if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let words = try? String(contentsOf: wordsFileURL) {
        var wordsArray = words.components(separatedBy: "\n")
        wordsArray.removeLast(1)
        for word in wordsArray {
          let newQuestion = Question(word: word, letters: word.count)
          questions.append(newQuestion)
        }
        setupLevel()
        lifes = 7
        score = 0
      }
    }
  }

  private func setupLevel() {
    lifes < 1 ? questions.shuffle() : nil
    questions.shuffle()
    currentQuestion = questions[questionNumber - 1]
    currentPlaceholder = getPlaceholderString()
    wordLetters = currentQuestion.letters
    wordPlaceholder = currentPlaceholder
    currentDiscoveredLetters.removeAll()
    print("current word: \(currentQuestion.word)")
  }

  private func checkLetterExistsReturnPosition(letter: Character) -> [String.Index]? {
    var currentWordAux = currentQuestion.word
    var positions = [String.Index]()
    while currentWordAux.contains(letter) {
      if let position = currentWordAux.firstIndex(of: letter) {
        positions.append(position)
        currentWordAux.remove(at: position)
        currentWordAux.insert(Character("?"), at: position)
      }
    }
    return (positions.count > 0 ? positions : nil)
  }

  private func checkWholeWordDiscovered() -> Bool {
    let discoveredLettersSorted = currentDiscoveredLetters.joined(separator: "").sorted()
    let currentWordSorted = currentQuestion.word.sorted()
    guard discoveredLettersSorted == currentWordSorted else { return false }
    return true
  }

  private func updateWordPlaceholder(letter: String) {
    guard !(currentDiscoveredLetters.contains(letter)) else { return }
    guard let letterPositions = checkLetterExistsReturnPosition(letter: Character(letter)) else {
      lifes -= 1
      if lifes < 1 {
        customAlert(title: "You lost", message: "Score: \(score)", actionTitle: "Play Again") { [weak self] _ in
          self?.setupLevel()
          self?.lifes = 7
        }
      }
      return
    }
    letterPositions.forEach { letterPosition in
      currentPlaceholder.remove(at: letterPosition)
      currentPlaceholder.insert(Character(letter), at: letterPosition)
      currentDiscoveredLetters.append(letter)
    }
    wordPlaceholder = currentPlaceholder
    guard checkWholeWordDiscovered() else { return }
    score += 1
    customAlert(title: "Congrats!", message: "", actionTitle: "Next word") { [weak self] _ in
      self?.nextWord()
    }
  }

  private func hintAlert() {
    let ac = UIAlertController(title: "Hint", message: "Getting a hint will cost you 1 life", preferredStyle: .alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    let hintAction = UIAlertAction(title: "Get hint", style: .default) { [weak self] _ in
      guard let strongSelf = self else { return }
      guard let currentQuestion = strongSelf.currentQuestion else { return }
      strongSelf.lifes -= 1
      for letter in currentQuestion.word {
        if !(strongSelf.currentDiscoveredLetters.contains(String(letter))) {
          strongSelf.updateWordPlaceholder(letter: String(letter))
          break
        }
      }
    }
    hintAction.setValue(UIColor.systemPink, forKey: "titleTextColor")
    ac.addAction(hintAction)
    ac.addAction(dismissAction)
    present(ac, animated: true)
  }

  private func customAlert(title: String, message: String, actionTitle: String, logic: @escaping (_ action: UIAlertAction) -> Void) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: logic))
    present(ac, animated: true)
  }

  private func nextWord() {
    questionNumber += 1
    if !(questionNumber <= questions.count) { questionNumber = 1 }
    setupLevel()
    wordPlaceholder = currentPlaceholder
  }

  private func hint() {
    guard lifes > 1 else { return }
    hintAlert()
  }
}

extension MainViewController: MainViewDelegate {
  var wordPlaceholder: String {
    get { return currentPlaceholder }
    set { mainView.wordToGuessInputField.text = newValue.uppercased() }
  }

  var wordLetters: Int {
    get { return currentQuestion.letters }
    set { mainView.wordLettersCountLabel.text = "# Letters: \(newValue)" }
  }

  var lifes: Int {
    get { return _lifes }
    set {
      _lifes = newValue
      mainView.lifesLabel.text = "Lifes: \(newValue)"
    }
  }

  func buttonPressed(_ sender: UIButton) {
    guard let text = sender.titleLabel?.text?.lowercased() else { return }
    if text == "next" { nextWord(); return }
    if text == "hint" { hint(); return }
    updateWordPlaceholder(letter: text)
  }

  var orientation: UIDeviceOrientation { return _orientation }
}
