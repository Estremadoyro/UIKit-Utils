//
//  NewNoteVC.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

final class NewNoteVC: UIViewController {
  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var noteTitleLabel: UITextField!
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var newNoteToolBarView: NewNoteToolBarView!

  weak var notesDelegate: NotesDelegate?
  var noteSceneType: NoteSceneType = .isCreatingNewNote
  var noteIndexPath = IndexPath(row: 0, section: 0)

  var notes: Notes? {
    didSet {
      print("notes recieved: \(notes ?? Notes(notes: [Note]()))")
    }
  }

  var note: Note?

  private lazy var newNoteNavigation = NewNoteNavigationBar(newNoteVC: self)

  override func viewDidLoad() {
    super.viewDidLoad()
    print("note scene type: \(noteSceneType)")
    newNoteNavigation.newNoteDelegate = self
    newNoteToolBarView.newNoteDelegate = self
    newNoteToolBarView.newNoteDataSource = self
    noteTitleLabel.delegate = self
    textView.delegate = self
    scrollView.delegate = self
    configureNavigationBar()
    configureNoteIfEditing(note: note)
    newNoteToolBarView.setClearItemState()
  }

  override func viewDidAppear(_ animated: Bool) {
    noteTitleLabel.becomeFirstResponder()
  }

  deinit { print("\(self) deinited") }
}

extension NewNoteVC {
  private func configureNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    newNoteNavigation.buildNavigationItems()
  }

  private func configureNoteIfEditing(note: Note?) {
    guard let note = note else { return }
    noteTitleLabel.text = note.title
    textView.text = note.body
  }
}

extension NewNoteVC {
  @objc
  private func dismissKeyboardTouchOutside() {
    textView.endEditing(true)
    noteTitleLabel.endEditing(true)
  }
}

extension NewNoteVC: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    textView.resignFirstResponder()
    noteTitleLabel.resignFirstResponder()
  }
}

extension NewNoteVC: NewNoteDelegate {
  func willSaveNewNote() {
    guard var title = noteTitleLabel.text?.trimmingCharacters(in: .whitespaces) else { return }
    guard var body = textView.text?.trimmingCharacters(in: .whitespaces) else { return }

    if title == "" {
      title = "Unnamed note"
    }

    if body == "" {
      body = "No content 😢"
    }

    switch noteSceneType {
      case .isCreatingNewNote:
        createNewNote(title: title, body: body)
      case .isEditingNote:
        editNote(title: title, body: body)
    }
    navigationController?.popViewController(animated: true)
  }

  func didClearNewNote() {
    noteTitleLabel.text? = ""
    textView.text? = ""
  }
}

extension NewNoteVC: NewNoteDataSource {
  func getNewNoteLength() -> Int {
    guard let titleCharsLength = noteTitleLabel.text?.count else {
      return 0
    }

    let bodyCharsLength = textView.text.count

    return titleCharsLength + bodyCharsLength
  }
}

extension NewNoteVC {
  private func createNewNote(title: String, body: String) {
    let note = Note(title: title, body: body)
    notes?.notes.append(note)
    notesDelegate?.didSaveNote(note: note)
  }

  private func editNote(title: String, body: String) {
    guard let notes = notes else { return }
    guard let note = note else { return }
    guard let noteToEditIndex = notes.notes.firstIndex(where: { $0.id == note.id }) else { return }
    print("[NOTES] NOTE TO EDIT INDEX: \(noteToEditIndex)")
    print("[NOTES] TITLE: \(title)")
    
    let noteToEdit = notes.notes[noteToEditIndex]
    print("[NOTES] NOTE TO EDIT: \(noteToEdit.title)")
    noteToEdit.title = title
    noteToEdit.body = body
    UserDefaults.standard.save(key: DefaultKeys.NOTES_KEY, obj: notes)
    notesDelegate?.didEditNote(note: noteToEdit, noteIndexPath: noteIndexPath)
  }
}

extension NewNoteVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    jumpToNextTextField(textField)
    return true
  }

  func jumpToNextTextField(_ textField: UITextField) {
    switch textField {
      case noteTitleLabel:
        textView.becomeFirstResponder()
      default:
        return
    }
  }

  func textFieldDidChangeSelection(_ textField: UITextField) {
    newNoteToolBarView.setClearItemState()
  }
}

extension NewNoteVC: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    newNoteToolBarView.setClearItemState()
  }
}
