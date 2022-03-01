//
//  NoteDelegate.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

protocol NewNoteDelegate: AnyObject {
  func willSaveNewNote()
  func didClearNewNote()
}

protocol NewNoteDataSource: AnyObject {
  func getNewNoteLength() -> Int
}

protocol NotesDelegate: AnyObject {
  func didSaveNote(note: Note)
  func didEditNote(note: Note)
}
