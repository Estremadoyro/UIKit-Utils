//
//  ViewController.swift
//  ReadingFileUserInputClosures
//
//  Created by Leonardo  on 16/12/21.
//

import UIKit

final class TableViewController: UITableViewController {
  var allWords = [String]()
  var usedWords = [String]()

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
    startGame()
  }

  private func navigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
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

  private func startGame() {
    /// # Gets a `random word`
    title = allWords.randomElement()
    navigationController?.navigationBar.prefersLargeTitles = true
    /// # Removes all the words from the loaded file in list
    usedWords.removeAll(keepingCapacity: true)
    /// # Reloads `sections` and `rows` of the view
    tableView.reloadData()
  }

  private func submitAnswer(answer: String) {
    usedWords.append(answer)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = usedWords[indexPath.row]
    cell.contentConfiguration = content
    return cell
  }
}
