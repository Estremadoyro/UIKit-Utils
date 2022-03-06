//
//  Note.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import Foundation

class Note: Codable, Identifiable {
  var id = UUID()
  var title: String
  var body: String
  var date = Date()
  var pinned: Bool = false

  init(title: String, body: String) {
    self.title = title
    self.body = body
  }

  deinit {
    print("\(self.title) (\(self.id)) deleted")
  }
}

extension Note: Hashable {
  static func == (lhs: Note, rhs: Note) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
