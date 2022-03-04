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
  lazy var notPinnedNotes = self.filterNotesByPinned(pin: .notPinned)
  lazy var pinnedNotes = self.filterNotesByPinned(pin: .isPinned)

  lazy var filteredNotes: [Note] = (notes.copy(with: nil) as? Notes)?.notes ?? [Note]()

  var tableSectionsAmount: Int = 1 {
    didSet {
      assert(tableSectionsAmount <= 2 && tableSectionsAmount > 0, "# Sections can't be greater than 2 or lower than 0")
    }
  }

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
        guard let indexPath = tableView.indexPathForSelectedRow else {
          fatalError("ERROR PASSING INDEX PATH TO EDIT ROW")
        }
        newNoteVC?.notes = notes
        newNoteVC?.note = cellSender?.note
        newNoteVC?.notesDelegate = self
        newNoteVC?.noteSceneType = .isEditingNote
        newNoteVC?.noteIndexPath = indexPath
      default:
        return
    }
  }
}

extension HomeVC: NotesDelegate {
  func didSaveNote(note: Note) {
    print("did save note")
    filteredNotes.append(note)
    pinnedNotes = filterNotesByPinned(pin: .isPinned)
    notPinnedNotes = filterNotesByPinned(pin: .notPinned)
    insertIndexPath = IndexPath(row: 0, section: tableSectionsAmount > 1 ? 1 : 0)
  }

  func didEditNote(note: Note, noteIndexPath: IndexPath) {
    print("did edit note")
    print("NOTE NEW VALUE: \(note.title)")
    guard let editedNoteIndex = filteredNotes.firstIndex(where: { $0.id == note.id }) else {
      fatalError("Didn't find edited note: \(note.title) (\(note.id), pinned? \(note.pinned)")
    }
    print("edited note: \(filteredNotes[editedNoteIndex].title)")
    let editedNote = filteredNotes[editedNoteIndex]
    editedNote.title = note.title
    editedNote.body = note.body
//    let reversedIndex = (filteredNotes.count - 1) - editedNoteIndex
    print("EDITED NOTE: \(editedNote.title) INDEXPATH - row: \(noteIndexPath.row), section: \(noteIndexPath.section)")
    pinnedNotes = filterNotesByPinned(pin: .isPinned)
    notPinnedNotes = filterNotesByPinned(pin: .notPinned)
    let indexPath = IndexPath(row: noteIndexPath.row, section: noteIndexPath.section)
    editIndexPath = indexPath
  }
}
