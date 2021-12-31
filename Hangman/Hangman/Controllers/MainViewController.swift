//
//  ViewController.swift
//  Hangman
//
//  Created by Leonardo  on 26/12/21.
//

import UIKit

class MainViewController: UIViewController {
  var questions = [Question]()
  var currentWord: String = ""
  var currentPlaceholder: String = "?"
  var currentDiscoveredLetters = [String]()
  var currentWordLetters: Int = 0
  var lifes: Int = 7

  private lazy var mainView: MainView = {
    readWordsFile()
    let mainView = MainView(frame: UIScreen.main.bounds, wordToGuessLetters: currentWordLetters, wordPlaceholder: currentPlaceholder)
    mainView.delegate = self
    return mainView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mainView)
    print("current word: \(currentWord)")
  }

  override func viewDidAppear(_ animated: Bool) {
    mainView.generateAlphabetButtons()
  }

  private func setCurrentWordLetters() -> Int {
    return currentWord.count
  }

  private func getPlaceholderString() -> String {
    return currentWord.reduce("") { placeholder, _ in
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
          let newQuestion = Question(word: word, letters: wordsArray.count)
          questions.append(newQuestion)
          currentWord = questions[0].word
          currentPlaceholder = getPlaceholderString()
          currentWordLetters = setCurrentWordLetters()
        }
      }
    }
  }

  private func checkLetterExistsReturnPosition(letter: Character) -> [String.Index]? {
    var currentWordAux = currentWord
    var positions = [String.Index]()
//    guard let position = currentWord.firstIndex(of: Character(letter)) else { return nil }
    for letter in currentWord {
      if let position = currentWordAux.firstIndex(of: letter) {
        print("position found: \(position)")
        positions.append(position)
        currentWordAux.remove(at: position)
        print("new currentWordAux: \(currentWordAux)")
      }
    }
    return positions
  }

  private func checkWholeWordDiscovered() -> Bool {
    let joinedDiscoveredLetters = currentDiscoveredLetters.joined(separator: "")
    guard !(joinedDiscoveredLetters == currentWord) else { return false }
    return true
  }

  private func updateWordPlaceholder(letter: String) {
    guard let letterPositions = checkLetterExistsReturnPosition(letter: Character(letter)) else { return }
    guard checkWholeWordDiscovered() else {
      print("whole word discovered, placeholder: \(currentPlaceholder)")
      return
    }
    letterPositions.forEach { letterPosition in
      currentPlaceholder.remove(at: letterPosition)
      currentPlaceholder.insert(Character(letter), at: letterPosition)
      currentDiscoveredLetters.append(letter)
    }
    wordPlaceholder = currentPlaceholder
    print("new placeholder \(currentPlaceholder)")
  }

  private func nextWord() {
    print("next word")
  }

  private func hint() {
    print("hint")
  }
}

extension MainViewController: MainViewDelegate {
  var wordPlaceholder: String {
    get {
      return currentPlaceholder
    }
    set {
      mainView.wordToGuessInputField.text = newValue
    }
  }

  func buttonPressed(_ sender: UIButton) {
    guard let text = sender.titleLabel?.text?.lowercased() else { return }
    if text == "next" { nextWord(); return }
    if text == "hint" { hint(); return }
    updateWordPlaceholder(letter: text)
  }
}
