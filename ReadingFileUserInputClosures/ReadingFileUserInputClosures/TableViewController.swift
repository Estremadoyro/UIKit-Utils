//
//  ViewController.swift
//  ReadingFileUserInputClosures
//
//  Created by Leonardo  on 16/12/21.
//

import UIKit

final class TableViewController: UITableViewController {
  private let CURRENT_WORD_KEY = "current-word"
  private let WORD_ATTEMPTS_KEY = "word-attempts"

  var allWords = [String]()
  var usedWords = [String]()
  private var currentWord: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    /// # Set the `navigation bar items`
    navigationBar()
    /// # Reading from `Bundle`
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
      /// # Cast the file to `String` type
      /// # This method can `throw`, so its needed to use `try? or try`
      if let startWords = try? String(contentsOf: startWordsURL) {
        /// # Set the property `allWords` value
        /// # Set the separator to make an array
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    /// # If the `file` is not `found` then set it to a default value
    if allWords.isEmpty {
      allWords = ["NO_WORDS_LOADED"]
    }
    loadGameData()
    setUpGame()
  }

  private func navigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  /// # Method to call when the `bar button item` is pressed
  @objc private func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField(configurationHandler: nil)
    /// # Add alert button, using `trailing closure` for the handler
    /// # `self` is being strongly captured by the closure, making it a `reference cycle`
    /// # As `submitAction's closure` references to `TableViewController`, and `TableViewController` references to `submitAction's closure`
    /// # So, `submitAction` can't die, as long as `ViewController` exists, and `ViewController` has an `prompForAnswer` that has a `trailing closure` that references to itself (`ViewController`), so it `can't die either`
    /// # `submitAction` can only die when `UIAlertController` gets destroyed, but `UIAlertController` will only die when `submitAction` gets destroyed first. (Strong Reference Cycle)
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
      /// # Call the `submitAnswer` method, with the `answer`, which comes from the `textField` pos. 0
      guard let answer = ac?.textFields?[0].text else { return }
      self?.submitAnswer(answer: answer)
      /// # Neither `self` or `ac` are `owned` by the `trailing closure`
    }
    ac.addAction(submitAction)
    present(ac, animated: true)
  }

  deinit {
    print("TableView controller destroyed")
  }

  @objc private func restartGame() {
    guard let currentWord = allWords.randomElement() else { return }
    self.currentWord = currentWord
    title = self.currentWord
    usedWords.removeAll()
    saveGameData(data: usedWords, key: WORD_ATTEMPTS_KEY)
    saveGameData(data: self.currentWord, key: CURRENT_WORD_KEY)
    tableView.reloadData()
  }

  private func setUpGame() {
    /// # Gets a `random word`
    title = currentWord
    saveGameData(data: currentWord, key: CURRENT_WORD_KEY)
    /// # Removes all the words from the loaded file in list
//    usedWords.removeAll(keepingCapacity: true)
    /// # Reloads `sections` and `rows` of the view
//    tableView.reloadData()
  }

  private func submitAnswer(answer: String) {
    let lowerAnswer = answer.lowercased()

    guard isPossible(answer: lowerAnswer) else {
      showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title!.lowercased())")
      return
    }

    guard isOriginal(answer: lowerAnswer) else {
      showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
      return
    }
    guard isReal(answer: lowerAnswer) else {
      showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up bruhh")
      return
    }
    /// # Passed all the filters, is an acceptable word
    insertWordInTable(answer: lowerAnswer)
  }

  private func showErrorMessage(errorTitle title: String, errorMessage message: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(ac, animated: true)
  }

  private func insertWordInTable(answer word: String) {
    /// # Insert the `word` at possition `0`
    usedWords.insert(word, at: 0)
    saveGameData(data: usedWords, key: WORD_ATTEMPTS_KEY)
    /// # New `IndexPath` (List of indexes ``row and section indexes``) which points at the `first row`
    let indexPath = IndexPath(row: 0, section: 0)
    /// # This is needed to display the `animation` of the new `cell` animating from top
    tableView.insertRows(at: [indexPath], with: .left)
  }

  /// # Word hasn't been used before, that is not the same as the `title word`, and it's longer than 3 letters
  private func isOriginal(answer word: String) -> Bool {
    return !usedWords.contains(word) && word != title?.lowercased() && word.count >= 3
  }

  /// # Word can't be made from the `title` word
  private func isPossible(answer word: String) -> Bool {
    /// # Create a `tempWord` of the word to play with
    guard var tempWord = title?.lowercased() else { return false }
    /// # Loop through every `letter` in the `word answer`
    for letter in word {
      /// # Look for the `answer letter` position inside the `play word (title)`
      if let position = tempWord.firstIndex(of: letter) {
        /// # If `found` then `remove` it from the `tempWord` list, in order to prevent answer letters passing the test, if those are repeated more times than in the `play word (title)`
        tempWord.remove(at: position)
        /// # Answer letter doesn't exist in the `play word (title)`, so it fails
      } else {
        return false
      }
    }
    /// # If no answer letters were repeated or didn't exist
    return true
  }

  /// # Word is `misspelled`
  private func isReal(answer word: String) -> Bool {
    /// # Instantiate the `UIKit` letter checker obj.
    let checker = UITextChecker()
    /// # Range the checker will be cheaking for a misspelling
    /// # `location` starting position, `utf16` is a `16 Bit Unicode Transformation Format`, compatibility with `Objective-C`
    let range = NSRange(location: 0, length: word.utf16.count)
    /// # If there is a `misspelled word`, then return the `range`
    /// # `wrap`: If there is no `misspelled word` then start from the `startingAt` position
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    /// # If `misspelledRange` didn't find any spelling errors, then there is no `starting position` for a wrong word
    return misspelledRange.location == NSNotFound
  }

  override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }

  override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = usedWords[indexPath.row]
    cell.contentConfiguration = content
    cell.selectionStyle = .none
    return cell
  }

  private func saveGameData<T>(data: T, key: String) {
    UserDefaults.standard.set(data, forKey: key)
    print("saved game data: \(data) @ \(key)")
  }

  private func loadGameData() {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let strongSelf = self else { return }
      if let currentWord = UserDefaults.standard.string(forKey: strongSelf.CURRENT_WORD_KEY) {
        strongSelf.currentWord = currentWord
        print("UD - currentWord: \(currentWord)")
      } else {
        if let randomWord = strongSelf.allWords.randomElement() {
          strongSelf.currentWord = randomWord
        }
      }
      if let usedWords = UserDefaults.standard.array(forKey: strongSelf.WORD_ATTEMPTS_KEY) as? [String] {
        strongSelf.usedWords = usedWords
        print("UD - currentWord: \(usedWords)")
      } else {
        strongSelf.usedWords.removeAll()
      }
    }
    print("- currentWord: \(UserDefaults.standard.value(forKey: CURRENT_WORD_KEY))")
    print("- usedWords: \(UserDefaults.standard.value(forKey: WORD_ATTEMPTS_KEY))")
  }
}
