//
//  ViewController.swift
//  Project24-NSAttributedString
//
//  Created by Leonardo  on 12/03/22.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet private weak var titleLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    playground()
    challenge()
  }
}

extension ViewController {
  private func playground() {
    let name: String = "leonardo"
    let password: String = "wakanda"
    let protagonist: String = "Senku"

    // This will cause a Nested Loop O^2
    // 1. Looping through all the letters (Characters)
    // 2. Looping through all the letters again per letter, due to the subscript created
    for i in 0 ..< name.count {
      print(name[i])
    }

    // O(n)
    for i in 0 ..< name.count {
      print(name[name.index(name.startIndex, offsetBy: i)])
    }

    print("\u{1F603}")
    print("\u{1F1FA}\u{1F1F8}")

    let updatedPasswordPrefix: String = password.deletePrefix("90394")
    print("udpated password: \(updatedPasswordPrefix)")

    let updatedPasswordSuffix: String = password.deleteSuffix("da")
    print("udpated password: \(updatedPasswordSuffix)")

    let nameFirstLetterUppercased: String = name.capitalizedFirst
    print("capitalized first letter name: \(nameFirstLetterUppercased)")

    let quote: String = "Senku: Let's get excited!"
    print(quote.contains("excited"))

    let characters: [String] = ["Senku", "Kohaku", "Chrome"]
    print(characters.contains(protagonist))

    // Check if any String in the Characers Array exists in the Quote
    let characterContained: Bool = quote.containsAny(characters)
    print("Character is list: \(characterContained)")

    // Sequence.contains(): Returns True if 1 element of the Sequence satisfy the argument (Bool expression)
    let characterContainedElegant: Bool = characters.contains(where: { quote.contains($0) })
    print("Character is list (Elegant) : \(characterContainedElegant)")

    /// # String formatting (NSAttributedString)
    let sentence: String = "Stone World"
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .backgroundColor: UIColor.systemRed,
      .font: UIFont.boldSystemFont(ofSize: 36)
    ]
    let attributedString = NSAttributedString(string: sentence, attributes: attributes)
    titleLabel.attributedText = attributedString

    /// # Multiple inline String Attributes (NSMutableAttributedString)
    let mutableAttributedString = NSMutableAttributedString(string: sentence)
    mutableAttributedString.addAttribute(.backgroundColor, value: UIColor.systemGreen, range: NSRange(location: 0, length: sentence.count))
    mutableAttributedString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: 5))
    mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 36), range: NSRange(location: 0, length: 5))
    mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 48), range: NSRange(location: 6, length: sentence.count - 6))
    self.titleLabel.attributedText = mutableAttributedString
  }
}

// High risk of creating a nested loop when looping through letters (Characters) in a String
extension String {
  subscript(i: Int) -> String {
    return String(self[index(startIndex, offsetBy: i)])
  }
}

extension String {
  func deletePrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }

  func deleteSuffix(_ suffix: String) -> String {
    guard self.hasSuffix(suffix) else { return self }
    return String(self.dropLast(suffix.count))
  }
}

extension String {
  // capitalize first letter
  var capitalizedFirst: String {
    guard let firstLetter: Character = self.first else { return self }
    return firstLetter.uppercased() + self.dropFirst()
  }

  // check if array contains a given String
  // NOT ELEGANT
  func containsAny(_ array: [String]) -> Bool {
    for item in array {
      if self.contains(item) {
        return true
      }
    }
    return false
  }
}

/// # Challenges
extension ViewController {
  private func challenge() {
    let protagonist: String = "Senku"
    let characterWithPrefix: String = protagonist.withPrefix("Dr. ")
    print("[Challenge] \(characterWithPrefix)")

    let numericInString: String = "23"
    let numericfFromString = numericInString.isNumeric
    print("[Challenge] String \(numericInString) contains a number? -\(numericfFromString)")

    let multiLineString: String = "this\nis\na\ntest"
    let newLinesArray: [String] = multiLineString.lines
    print("[Challenge] Lines: \(newLinesArray)")
  }
}

public extension String {
  // Append prefix to String, unless it has it already
  func withPrefix(_ prefix: String) -> String {
    // If word is empty, then return the same
    guard !self.isEmpty else { return "" }
    // Get wordPrefix last index
    let prefixEndIndex: String.Index = self.index(self.startIndex, offsetBy: prefix.count)
    // Get wordPrefix's string (prefix)
    let inputPrefix = String(self.prefix(upTo: prefixEndIndex))
    // If prefixes are the same, then don't do nothing
    guard inputPrefix != prefix else { return self }
    // If it doesn't already have the prefix, append it
    return prefix + self
  }

  // Check if String holds any sort of number
  var isNumeric: Bool {
    return (Double(self) != nil ? true : false)
  }

  var lines: [String] {
    return self.components(separatedBy: .newlines)
  }
}
