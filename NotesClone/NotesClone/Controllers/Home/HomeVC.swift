//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

final class HomeVC: UIViewController {
  @IBOutlet weak var tableView: HomeTableView!
  @IBOutlet weak var homeToolbar: HomeToolBarView!
  @IBOutlet weak var homeSearchBar: UISearchBar!

  var homeNavigationBar: HomeNavigationBar?
  var editIndexPath: IndexPath?
  var insertIndexPath: IndexPath?

  lazy var notes = Notes()
  var notPinnedNotes = [Note]()
  var pinnedNotes = [Note]()
  lazy var filteredNotes: [Note] = (notes.copy(with: nil) as? Notes)?.notes ?? [Note]()

  var tableSectionsAmount: Int = 1

  override func viewDidLoad() {
    super.viewDidLoad()
//    UserDefaults.standard.reset()
    tableView.dataSource = self
    tableView.delegate = self
    homeSearchBar.delegate = self
    configureNavigationBar()
    configureToolbar()
    configureGestures()
    notes.notes.forEach { print("pinned: \($0.pinned)") }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let editIndexPath = editIndexPath {
      tableView.reloadRows(at: [editIndexPath], with: .automatic)
      self.editIndexPath = nil
    }

    if let insertIndexPath = insertIndexPath {
      tableView.insertRows(at: [insertIndexPath], with: .automatic)
      self.insertIndexPath = nil
    }
  }

  deinit { print("\(self) deinited") }
}

extension HomeVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    homeNavigationBar = HomeNavigationBar(homeTableVC: self)
    homeNavigationBar?.buildNavigationBarItems()
  }

  private func configureToolbar() {
    homeToolbar.configureHomeToolBar(notes: notes)
  }
}

extension HomeVC {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
      case HomeConstants.goToNewNoteVCSegueId:
        // New Note
        let newNoteVC = segue.destination as? NewNoteVC
        newNoteVC?.notes = notes
        newNoteVC?.notesDelegate = self
      case HomeConstants.goToEditNoteSegueId:
        // Edit Note
        let cellSender = sender as? NoteCellView
        let newNoteVC = segue.destination as? NewNoteVC
        newNoteVC?.notes = notes
        newNoteVC?.note = cellSender?.note
        newNoteVC?.notesDelegate = self
        newNoteVC?.noteSceneType = .isEditingNote
      default:
        return
    }
  }
}

extension HomeVC: NotesDelegate {
  func didSaveNote(note: Note) {
    print("did save note")
    filteredNotes.append(note)
    insertIndexPath = IndexPath(row: 0, section: tableSectionsAmount > 1 ? 1 : 0)
  }

  func didEditNote(note: Note) {
    print("did edit note")
    guard let editedNoteIndex = filteredNotes.firstIndex(where: { $0.id == note.id }) else { return }
    let editedNote = filteredNotes[editedNoteIndex]
    editedNote.title = note.title
    editedNote.body = note.body
    let reversedIndex = (filteredNotes.count - 1) - editedNoteIndex
    let indexPath = IndexPath(row: reversedIndex, section: 0)
    editIndexPath = indexPath
  }
}
