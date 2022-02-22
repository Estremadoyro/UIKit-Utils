//
//  HomeVC+Table.swift
//  NotesClone
//
//  Created by Leonardo  on 21/02/22.
//

import UIKit

extension HomeVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstants.notesCellId, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(HomeConstants.notesCellId)")
    }
    let note = filteredNotes.reversed()[indexPath.row]
    cell.note = note
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredNotes.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}
