//
//  HomeVC+Table.swift
//  NotesClone
//
//  Created by Leonardo  on 21/02/22.
//

import UIKit

enum NotePinState {
  case isPinned
  case notPinned
}

extension HomeVC: UITableViewDataSource {
  fileprivate func getIndexForSection(in indexPath: IndexPath) -> Int {
    var sumRowsBySection: Int = 0
    for section in 0 ..< indexPath.section {
      sumRowsBySection += tableView.numberOfRows(inSection: section)
    }
    return sumRowsBySection + indexPath.row
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstants.notesCellId, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(HomeConstants.notesCellId)")
    }
    let pinnedNotes: [Note] = notes.filterNotesPinned(pin: .isPinned)
    let notPinnedNotes: [Note] = notes.filterNotesPinned(pin: .notPinned)
    var note = notPinnedNotes[indexPath.row]

    if tableView.numberOfSections == 2, indexPath.section == 0 {
      note = pinnedNotes[indexPath.row]
    }

    cell.note = note
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return tableSectionsAmount
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard tableView.numberOfSections > 1 else {
      return filteredNotes.count
    }

    let pinnedNotesAmount: Int = notes.filterNotesPinned(pin: .isPinned).count
    print("PINNED NOTES AMOUNT: \(pinnedNotesAmount)")
    let remainingNormalNotesAmount = notes.notes.count - pinnedNotesAmount
    print("NEW NUMBER OF ROWS IN SECTION: \(remainingNormalNotesAmount)")
    return section == 1 ? remainingNormalNotesAmount : pinnedNotesAmount
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard tableView.numberOfSections == 2 else {
      return ""
    }
    return section == 0 ? "Pinned" : "Notes"
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1
  }
}

extension HomeVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [unowned self] _, _, completion in
      defer {
        homeToolbar.configureHomeToolBar(notes: notes)
        completion(true)
      }
      let globalIndex: Int = self.getIndexForSection(in: indexPath)
      self.notes.deleteNote(&self.filteredNotes, note: self.notes.notes[globalIndex])

      let pinnedNotesAmount: Int = notes.filterNotesPinned(pin: .isPinned).count
      self.tableView.deleteRows(at: [indexPath], with: .left)

      if tableView.numberOfSections == 2, pinnedNotesAmount == 0 {
        self.tableSectionsAmount = 1
        tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .left)
      }
    }

    let moveToFolderActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { _, _, completion in
      completion(true)
    }

    let shareWithContactActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { _, _, completion in
      completion(true)
    }

    let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteActionCompletion)
    deleteAction.image = UIImage(systemName: "trash.fill")
    deleteAction.image?.withTintColor(UIColor.yellow)

    let moveToFolderAction = UIContextualAction(style: .normal, title: "Move", handler: moveToFolderActionCompletion)
    moveToFolderAction.image = UIImage(systemName: "folder.fill")
    moveToFolderAction.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.5)

    let shareWithContactAction = UIContextualAction(style: .normal, title: "Share", handler: shareWithContactActionCompletion)
    shareWithContactAction.image = UIImage(systemName: "person.crop.circle.badge.plus")
    shareWithContactAction.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)

    let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, moveToFolderAction, shareWithContactAction])
    swipeConfig.performsFirstActionWithFullSwipe = false
    return swipeConfig
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pinActionCompletion: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { [weak self] _, _, completion in
      guard let strongSelf = self else { return }
      defer {
        let pinnedNotesAmount: Int = strongSelf.notes.filterNotesPinned(pin: .isPinned).count
        let pinnedIndexPath = IndexPath(row: 0, section: 0)
        var notPinnedIndexPath = indexPath
        // If note is first to be pinned, update Index (section 1) after creating the section
        if pinnedNotesAmount == 0 {
          notPinnedIndexPath = IndexPath(row: indexPath.row, section: 1)
        }
        print("[PIN] notPinnedIndexPath - row: \(notPinnedIndexPath.row) | section: \(notPinnedIndexPath.section)")
        // Global index to update with the Notes' list
        let globalIndex: Int = strongSelf.getIndexForSection(in: indexPath)
        strongSelf.notes.pinNote(&strongSelf.filteredNotes, noteIndex: globalIndex)
        tableView.moveRow(at: notPinnedIndexPath, to: pinnedIndexPath)
        completion(true)
      }

      if tableView.numberOfSections < 2 {
        strongSelf.tableSectionsAmount += 1
        tableView.insertSections(IndexSet(arrayLiteral: 0), with: .left)
      }
    }
    let pinAction = UIContextualAction(style: .normal, title: nil, handler: pinActionCompletion)
    let pinImageName = tableSectionsAmount > 1 && indexPath.section == 0 ? "pin.slash.fill" : "pin.fill"
    pinAction.image = UIImage(systemName: pinImageName)
    pinAction.backgroundColor = UIColor.systemOrange.withAlphaComponent(1)

    let swipeConfig = UISwipeActionsConfiguration(actions: [pinAction])
    swipeConfig.performsFirstActionWithFullSwipe = true
    return swipeConfig
  }
}

extension HomeVC {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    homeSearchBar.resignFirstResponder()
  }
}

extension HomeVC {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
