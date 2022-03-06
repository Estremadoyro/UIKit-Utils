//
//  Notes.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

final class Notes: Codable, NSCopying {
  var notes: [Note] {
    didSet {
      print("NOTES OBJ UPDATED")
    }
  }

  func copy(with zone: NSZone? = nil) -> Any {
    let copiedNotes = Notes(notes: notes)
    return copiedNotes
  }

  init() {
    self.notes = UserDefaults.standard.load(key: DefaultKeys.NOTES_KEY, obj: Notes.self)?.notes ?? [Note]()
    notes.forEach { print("Note loaded: \($0.title)") }
  }

  // needed for copying (not deep)
  init(notes: [Note]) {
    self.notes = notes
  }
}

extension Notes {
  public func filterNotesPinnedAmount(pin: NotePinState) -> [Note] {
    return notes.filter { pin == .isPinned ? $0.pinned : !$0.pinned }
  }
}

extension Notes {
  fileprivate func logUpdatedList() {
    // log new notes after any CRUD operation
    print("[CRUD] Notes: \(notes.map { "\($0.title) (P: \($0.pinned))" })")
  }

  public func saveNotesToLocal() {
    // save Notes into UserDefaults
    UserDefaults.standard.save(key: DefaultKeys.NOTES_KEY, obj: self)
    logUpdatedList()
  }

  static func updateNotesPosition() {
    // update notes position
  }
}

extension Notes {
  public func insertNewNote(_ filteredNotes: inout [Note], note: Note) {
    // insert new note (add logic for pinned notes)
    let pinnedNotesAmount: Int = filterNotesPinnedAmount(pin: .isPinned).count
    notes.insert(note, at: pinnedNotesAmount == 0 ? 0 : pinnedNotesAmount)
    print("did insert new note: \(note.title)")
    filteredNotes = notes
    saveNotesToLocal()
  }

  public func updateNote(_ filteredNotes: inout [Note], noteIndexPath: IndexPath, title: String, body: String) {
    // update note
    guard let noteToEdit: Note = notes.first(where: { $0.id == notes[noteIndexPath.row].id }) else { return }
    noteToEdit.title = title
    noteToEdit.body = body
    filteredNotes = notes
    saveNotesToLocal()
  }

  public func deleteNote(_ filteredNotes: inout [Note], note: Note) {
    // delete note
    notes.removeAll(where: { $0.id == note.id })
    filteredNotes = notes
    saveNotesToLocal()
  }

  public func pinNote(_ filteredNotes: inout [Note], noteIndex: Int) {
    // pin note
    guard let noteToPin: Note = notes.first(where: { $0.id == notes[noteIndex].id }) else { return }
    noteToPin.pinned = true
    notes.remove(at: noteIndex)
    notes.insert(noteToPin, at: 0)
    filteredNotes = notes
    saveNotesToLocal()
  }

  public func unPinNote() {
    // unpin note
  }
}
