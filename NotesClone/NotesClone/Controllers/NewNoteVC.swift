//
//  NewNoteVC.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NewNoteVC: UIViewController {
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var scrollView: UIScrollView!

  let headerAttributes = [kCTFontAttributeName: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
  let bodyAttributes = [kCTFontAttributeName: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]

  private lazy var newNoteNavigation = NewNoteNavigation(newNoteVC: self)
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    highlightFirstLineInTextView()
    scrollView.delegate = self
    textView.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    textView.becomeFirstResponder()
  }
}

extension NewNoteVC {
  private func configureNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    newNoteNavigation.buildNavigationItems()
  }
}

extension NewNoteVC {
  @objc
  private func dismissKeyboardTouchOutside() {
    textView.endEditing(true)
  }
}

extension NewNoteVC: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    print("began dragging")
    textView.resignFirstResponder()
  }
}

extension NewNoteVC: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let textAsNSString = self.textView.text as NSString
    let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
    let boldRange = replaced.range(of: "\n")
    if boldRange.location <= range.location {
      self.textView.typingAttributes = headerAttributes as [NSAttributedString.Key: Any]
    } else {
      self.textView.typingAttributes = bodyAttributes as [NSAttributedString.Key: Any]
    }

    return true
  }

  private func highlightFirstLineInTextView() {
    let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
    let textAsNSString = textView.text as NSString
    let boldFont = UIFont.boldSystemFont(ofSize: 24) as Any
    let normalFont = UIFont.preferredFont(forTextStyle: .body) as Any
    let lineBreakRange: NSRange = NSRange(textView.text!.lineRange(for: ..<textView.text!.startIndex), in: textView.text!)
    let boldRange: NSRange
    let normalRange: NSRange

    print("line break range: \(lineBreakRange.location)")
    print("nsstring length: \(textAsNSString.length)")
    if lineBreakRange.location < textAsNSString.length {
      boldRange = NSRange(location: 0, length: lineBreakRange.location)
      normalRange = NSRange(location: lineBreakRange.location, length: attributedText.length)
    } else {
      boldRange = NSRange(location: 0, length: attributedText.length)
      normalRange = NSRange(location: 0, length: 0)
    }

    attributedText.addAttribute(NSAttributedString.Key.font, value: boldFont, range: boldRange)
    attributedText.addAttribute(NSAttributedString.Key.font, value: normalFont, range: normalRange)
    textView.attributedText = attributedText
  }
}
