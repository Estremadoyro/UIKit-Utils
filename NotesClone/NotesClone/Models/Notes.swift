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
      UserDefaults.standard.save(key: DefaultKeys.NOTES_KEY, obj: self)
    }
    willSet {
      print("NOTES LSIT UPDATED")
    }
  }

  func copy(with zone: NSZone? = nil) -> Any {
    let copiedNotes = Notes()
    return copiedNotes
  }

  init() {
    self.notes = UserDefaults.standard.load(key: DefaultKeys.NOTES_KEY, obj: Notes.self)?.notes ?? [Note]()
    self.notes.forEach { print("Note loaded: \($0.title)") }
  }

  // needed for deep copying
  init(notes: [Note]) {
    self.notes = notes
  }

  convenience init(notes: Notes) {
    self.init(notes: notes.notes)
  }
}
