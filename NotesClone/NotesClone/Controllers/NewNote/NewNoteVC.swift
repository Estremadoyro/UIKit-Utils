//
//  NewNoteVC.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NewNoteVC: UIViewController {
  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var noteTitleLabel: UITextField!
  @IBOutlet private weak var scrollView: UIScrollView!

  weak var notesDelegate: NotesDelegate?
  var noteSceneType: NoteSceneType = .isCreatingNewNote

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
    newNoteNavigation.noteDelegate = self
    noteTitleLabel.delegate = self
    scrollView.delegate = self
    configureNavigationBar()
    configureNoteIfEditing(note: note)
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

  private func createNewNote(title: String, body: String) {
    let note = Note(title: title, body: body)
    notes?.notes.append(note)
    notesDelegate?.didSaveNote(note: note)
  }

  private func editNote(title: String, body: String) {
    guard let notes = notes else { return }
    guard let note = note else { return }
    guard let noteToEditIndex = notes.notes.firstIndex(where: { $0.id == note.id }) else { return }
    let noteToEdit = notes.notes[noteToEditIndex]
    noteToEdit.title = title
    noteToEdit.body = body
    UserDefaults.standard.save(key: DefaultKeys.NOTES_KEY, obj: notes)
    notesDelegate?.didEditNote(note: noteToEdit)
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
}
