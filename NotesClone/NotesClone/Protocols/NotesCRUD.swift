//
//  NotesCRUD.swift
//  NotesClone
//
//  Created by Leonardo  on 6/03/22.
//

import Foundation

protocol NotesCRUD {
  func insertNewNote(_ filteredNotes: inout [Note], note: Note)

  func updateNote(_ filteredNotes: inout [Note], noteIndexPath: IndexPath, title: String, body: String)

  func deleteNote(_ filteredNotes: inout [Note], note: Note)

  func pinNote(_ filteredNotes: inout [Note], noteIndex: Int)

  func unPinNote(_ filteredNotes: inout [Note], noteIndex: Int)
}
