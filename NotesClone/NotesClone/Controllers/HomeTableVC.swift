//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeTableVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var homeSearchBar: UISearchBar!
  @IBOutlet weak var homeToolbar: UIToolbar!
  @IBOutlet weak var notesAmountItem: UIBarButtonItem!

  private let NOTES_CELL_ID = "NOTES_CELL"
  private let goToNewNoteVCSegueId = "goToNewNoteVC"

  private lazy var homeTableNavigationBar = HomeTableNavigationBar(homeTableVC: self)
  var notes = Notes()
  lazy var filteredNotes: [Note] = notes.copy(with: nil) as? [Note] ?? [Note]()

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    homeSearchBar.delegate = self
    configureNavigationBar()
    configureGestures()
    configureToolBar()
//    UserDefaults.standard.reset()
    print("notes: \(Unmanaged.passUnretained(notes).toOpaque())")
//    print("filteredNotes: \(Unmanaged.passUnretained(filteredNotes).toOpaque())")

    print(notes)
    print(filteredNotes)
    print("test")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("preparing for segue")
    if segue.identifier == goToNewNoteVCSegueId {
      let newNoteVC = segue.destination as? NewNoteVC
      newNoteVC?.notes = notes
      newNoteVC?.notesDelegate = self
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  deinit {
    print("\(self) deinited")
  }
}

extension HomeTableVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    homeTableNavigationBar.buildNavigationBarItems()
  }

  private func configureToolBar() {
    notesAmountItem.title = "\(notes.notes.count) Notes"
  }
}

extension HomeTableVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NOTES_CELL_ID, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(NOTES_CELL_ID)")
    }
    let note = notes.notes.reversed()[indexPath.row]
//    let note = filteredNotes.reversed()[indexPath.row]
    cell.note = note
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.notes.count
//    return filteredNotes.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

extension HomeTableVC: NotesDelegate {
  func didSaveNote() {
    print("did save note???")
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
}
