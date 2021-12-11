//
//  ViewController.swift
//  AssetCatalogButtonsColors
//
//  Created by Leonardo  on 11/12/21.
//

import UIKit

/// # The `Asssets` placeholder, holds mostly images, which are of `3 types:`
/// `x1, x2, x3`
/// # Each one of them represents an pixeal to unit ratio
/// # Where `x1` sizes are meant for `iOS 3` (This is now legacy)
/// # Where `x2` sizes mean `twice` as many pixels, due to apple using `Retina Displays` from now on
/// # Where `x3` sizes mean `three times` as many pixels, result from `Retina HD Displays`

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!

  var countries = [String]()
  var score: Int = 0
  var correctAnswer: Int = 0
  var questionsAsked: Int = 0
  var userIsCorrect: Bool = false
  var numberOfQuestions: Int = 5

  override func viewDidLoad() {
    super.viewDidLoad()
    button1.layer.borderWidth = 12
    button2.layer.borderWidth = 12
    button3.layer.borderWidth = 12
    button1.clipsToBounds = true
    button1.contentMode = .scaleToFill

    /// # `UIColor.` belongs to a `CALayer` which doesn't know what a `UIColor` is
    /// # Types of proerties `must match`
    /// # `UIButton.CALayer.UIColor` = `UIButton.CALayer.UIColor`
    /// # `.borderColor` is type`CGColor`, so `UIColor.lightGray` doesn't match the type itself (Is a `UIColor`), hence calls `.cgColor` in order to get the same type `CGColor`
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor

    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

    askQuestion()
  }

  private func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ... 2)
    questionsAsked += 1
    title = "Question: \(questionsAsked) (\(numberOfQuestions)) | \(countries[correctAnswer].uppercased()) | Score: \(score)"
    navigationController?.navigationBar.prefersLargeTitles = false
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
  }

  private func alertToDisplay(numberOfQuestion: Int, sender: UIButton) {
    if numberOfQuestion == numberOfQuestions {
      showFinalScoreAlert()
    } else {
      showResultAlert(sender: sender)
    }
  }

  private func showResultAlert(sender: UIButton) {
    var title: String
    var message: String
    let wrongSelectedFlagMsg: String = "That's the flag of \(countries[sender.tag].uppercased())"
    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1
      message = "Your score is \(score)"
      userIsCorrect = true
    } else {
      title = "Wrong"
      score = (score > 0 ? score - 1 : score)
      message = """
      \(wrongSelectedFlagMsg)
      Your score is \(score)
      """
      userIsCorrect = false
    }

    /// # Create an alert message showing if the player was `Correct` or `Wrong`
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    /// # The handler can be either a `closure` or a `function`
    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    /// # Show the alert
    present(ac, animated: true)
  }

  private func showFinalScoreAlert() {
    let title: String = "\(userIsCorrect ? "Correct" : "Incorrect")"
    let message: String =
      """
      All questions answered (\(questionsAsked))
      Final score: \(score)
      """
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestion))
    present(ac, animated: true)
    questionsAsked = 0
    score = 0
  }

  @IBAction func buttonTapped(_ sender: UIButton) {
    alertToDisplay(numberOfQuestion: questionsAsked, sender: sender)
  }
}
