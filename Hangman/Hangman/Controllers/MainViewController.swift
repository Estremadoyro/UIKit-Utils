//
//  ViewController.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

class MainViewController: UIViewController {
  var questions = [Question]()
  var currentQuestion: Question!
  var questionNumber = 1
  var currentPlaceholder: String = "?"
  var currentDiscoveredLetters = [String]()
  var lifes: Int = 7

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
    print("current word: \(currentQuestion.word)")
  }

  override func viewDidAppear(_ animated: Bool) {
    mainView.generateAlphabetButtons()
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
        wordsArray.shuffle()
        for word in wordsArray {
          let newQuestion = Question(word: word, letters: word.count)
          questions.append(newQuestion)
        }
        setupLevel()
      }
    }
  }

  private func setupLevel() {
    currentQuestion = questions[questionNumber - 1]
    currentPlaceholder = getPlaceholderString()
    wordLetters = currentQuestion.letters
    wordPlaceholder = currentPlaceholder
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
    return positions
  }

  private func checkWholeWordDiscovered() -> Bool {
    let joinedDiscoveredLettersSorted = currentDiscoveredLetters.joined(separator: "").sorted()
    let currentWordListSorted = currentQuestion.word.sorted()
    guard !(joinedDiscoveredLettersSorted == currentWordListSorted) else { return false }
    return true
  }

  private func updateWordPlaceholder(letter: String) {
    guard let letterPositions = checkLetterExistsReturnPosition(letter: Character(letter)) else { return }
    letterPositions.forEach { letterPosition in
      currentPlaceholder.remove(at: letterPosition)
      currentPlaceholder.insert(Character(letter), at: letterPosition)
      currentDiscoveredLetters.append(letter)
    }
    guard checkWholeWordDiscovered() else { return }
  }

  private func nextWord() {
    questionNumber += 1
    if !(questionNumber <= questions.count) { questionNumber = 1 }
    setupLevel()
    currentDiscoveredLetters.removeAll()
    wordPlaceholder = currentPlaceholder
    print("next word")
  }

  private func hint() {
    print("hint")
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

  func buttonPressed(_ sender: UIButton) {
    guard let text = sender.titleLabel?.text?.lowercased() else { return }
    if text == "next" { nextWord(); return }
    if text == "hint" { hint(); return }
    updateWordPlaceholder(letter: text)
    wordPlaceholder = currentPlaceholder
  }
}
