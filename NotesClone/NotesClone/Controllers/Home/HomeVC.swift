//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeVC: UIViewController {
  @IBOutlet weak var tableView: HomeTableView!
  @IBOutlet weak var homeSearchBar: UISearchBar!
  @IBOutlet weak var homeToolbar: HomeToolBarView!

  var homeNavigationBar: HomeNavigationBar?

  lazy var notes = Notes()
  lazy var filteredNotes: [Note] = (notes.copy(with: nil) as? Notes)?.notes ?? [Note]()

  override func viewDidLoad() {
    super.viewDidLoad()
    notes.notes.forEach { note in
      print("Initial note: \(note.title)")
    }
    filteredNotes.forEach { note in
      print("Initial filtered note: \(note.title)")
    }

    tableView.dataSource = self
    tableView.delegate = self
    homeSearchBar.delegate = self
    configureNavigationBar()
    configureGestures()
  }

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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    homeToolbar.configureHomeToolBar(notes: notes)
  }

  deinit { print("\(self) deinited") }
}

extension HomeVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    homeNavigationBar = HomeNavigationBar(homeTableVC: self)
    homeNavigationBar?.buildNavigationBarItems()
  }
}

extension HomeVC: NotesDelegate {
  func didSaveNote(note: Note) {
    filteredNotes.append(note)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    print("did save note")
  }

  func didEditNote(note: Note) {
    guard let editedNoteIndex = filteredNotes.firstIndex(where: { $0.id == note.id }) else { return }
    let editedNote = filteredNotes[editedNoteIndex]
    editedNote.title = note.title
    editedNote.body = note.body
    print("notes count: \(notes.notes.count)")
    print(notes.notes)
//    notes.notes = [Note]()
    print("notes count: \(notes.notes.count)")
    print("filtered notes count: \(filteredNotes.count)")
    print("did edit note")
    print(Unmanaged.passUnretained(notes).toOpaque())
    print(notes.notes)
    print(filteredNotes)
    tableView.reloadData()
  }
}
