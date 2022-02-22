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
}

extension HomeVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [unowned self] _, _, completion in
      self.notes.notes.remove(at: indexPath.row)
      self.filteredNotes.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .left)
      homeToolbar.configureHomeToolBar(notes: notes)
      completion(true)
    }

    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteActionCompletion)

    let iconImage = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysTemplate)

    deleteAction.image = iconImage
    deleteAction.image?.withTintColor(UIColor.systemPink)

    let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
    swipeConfig.performsFirstActionWithFullSwipe = true
    return swipeConfig
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    homeSearchBar.resignFirstResponder()
  }
}
