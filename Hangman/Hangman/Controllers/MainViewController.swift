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
  var currentWordLetters: Int = 0
  var lifes: Int = 7

  lazy var contentView = MainView(frame: UIScreen.main.bounds)

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {}

  override func viewDidAppear(_ animated: Bool) {
    contentView.generateAlphabetButtons()
  }

  public func setCurrentWordLetters(currentWord: String) -> Int {
    return currentWord.count
  }

  public func getPlaceholderString(currentWord: String) -> String {
    return currentWord.reduce("") { placeholder, _ in
      placeholder + "?"
    }
  }

  public func readWordsFile() {
    if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let words = try? String(contentsOf: wordsFileURL) {
        var wordsArray = words.components(separatedBy: "\n")
        wordsArray.removeLast(1)
        wordsArray.shuffle()
        for word in wordsArray {
          let newQuestion = Question(word: word, letters: wordsArray.count)
          questions.append(newQuestion)
          currentWord = questions[0].word
        }
      }
    }
  }

  @objc func buttonPressed(_ sender: UIButton) {
    guard let text = sender.titleLabel?.text else { return }
    print("letter pressed: \(text)")
  }
}
