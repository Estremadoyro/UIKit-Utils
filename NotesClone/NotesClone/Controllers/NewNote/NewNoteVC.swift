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

  weak var notesDelegate: NotesDelegate?

  weak var notes: Notes? {
    didSet {
      print("notes recieved: \(notes ?? Notes(notes: [Note]()))")
    }
  }

  private lazy var newNoteNavigation = NewNoteNavigationBar(newNoteVC: self)

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    scrollView.delegate = self
    newNoteNavigation.noteDelegate = self
    print(CFGetRetainCount(self))
  }

  override func viewDidAppear(_ animated: Bool) {
    textView.becomeFirstResponder()
    print("First line: \(textView.text.getFirstLine3())")
    print("Whol text length: \(textView.text.count)")
  }

  deinit {
    print("\(self) deinited")
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

extension NewNoteVC: NewNoteDelegate {
  func willSaveNewNote() {
    let note = Note(title: UUID().uuidString, body: textView.text)
    print("Text to save: \(textView.text ?? "")")
    notes?.notes.append(note)
    navigationController?.popViewController(animated: true)
    notesDelegate?.didSaveNote(note: note)
  }
}
