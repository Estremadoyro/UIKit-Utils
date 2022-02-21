//
//  NoteDelegate.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

protocol NewNoteDelegate: AnyObject {
  func willSaveNewNote()
}

protocol NotesDelegate: AnyObject {
  func didSaveNote()
}
