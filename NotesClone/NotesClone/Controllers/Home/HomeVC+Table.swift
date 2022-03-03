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
  internal func filterNotesByPinned(pin: NotePinState) -> [Note] {
    return notes.notes.filter { pin == .isPinned ? $0.pinned : !$0.pinned }
  }

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
    let note = filteredNotes.reversed()[indexPath.row]
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

    let pinnedNotesAmount = filterNotesByPinned(pin: .isPinned).count
    let remainingNormalNotesAmount = filteredNotes.count - pinnedNotesAmount
    print("SECTION 1 AMOUNT: \(remainingNormalNotesAmount)")
    print("SECTION 0 AMOUNT: \(pinnedNotesAmount)")
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
      self.notPinnedNotes = self.filterNotesByPinned(pin: .notPinned).reversed()
      self.pinnedNotes = self.filterNotesByPinned(pin: .isPinned).reversed()
      let globalIndex: Int = self.getIndexForSection(in: indexPath)
      var rowIndex = globalIndex - self.pinnedNotes.count
      var newIndexPath = IndexPath(row: rowIndex, section: 0)
      var noteToDelete = self.notPinnedNotes[rowIndex]
      var sectionNoteList: [Note] = self.notPinnedNotes
      // at least 1 pinned note (pin section exists)
      // if note is not pinned
      if indexPath.section == 1 {
        newIndexPath = IndexPath(row: rowIndex, section: 1)
      } else if indexPath.section == 0, tableView.numberOfSections == 2 {
        rowIndex = self.pinnedNotes.count - 1
        noteToDelete = self.pinnedNotes[rowIndex]
        sectionNoteList = self.pinnedNotes
      }
      // must be first, or noteToDelete will have already deleted the note (notPinnedNotes share same Note-item memory from Notes obj.)
      self.filteredNotes.removeAll(where: { $0.id == noteToDelete.id })
      // also removes from Notes obj, sharing same [Note] address
      sectionNoteList.remove(at: rowIndex)
      print("new notes: \(self.notes.notes.map { $0.title })")
      self.tableView.deleteRows(at: [newIndexPath], with: .left)
//      self.notes.notes.remove(at: indexPath.row)
//      self.filteredNotes.remove(at: indexPath.row)
//      self.tableView.deleteRows(at: [indexPath], with: .left)
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
        strongSelf.notPinnedNotes = strongSelf.filterNotesByPinned(pin: .notPinned).reversed()
        strongSelf.pinnedNotes = strongSelf.filterNotesByPinned(pin: .isPinned).reversed()
//        let rowsPinned: Int = tableView.numberOfRows(inSection: 0)
        let globalIndex: Int = strongSelf.getIndexForSection(in: indexPath)
        print("global index: \(globalIndex)")
        print("# PINNED notes: \(strongSelf.pinnedNotes.count)")
        print("NOT pinned notes: \(strongSelf.notPinnedNotes.map { $0.title })")
        print("CURRENT SECTION: \(indexPath.section)")
        // || pinnedNotes == 0 -> To allow the first unpinned note to pass
        // Note to pin
        if indexPath.section == 1 || strongSelf.pinnedNotes.count == 0 {
          let noteToPin: Note = strongSelf.notPinnedNotes[globalIndex - strongSelf.pinnedNotes.count]
          noteToPin.pinned.toggle()
          print("noteToPin: \(noteToPin.title)")
          print("ALL CURRENT NOTES OBJ PINN STATUS: \(strongSelf.notes.notes.map { $0.pinned })")

          let pinnedIndex = IndexPath(row: 0, section: 0)
          let normalIndex = IndexPath(row: indexPath.row, section: 1)

          if noteToPin.pinned {
            print("new note toggled: \(noteToPin.pinned)")
            tableView.moveRow(at: normalIndex, to: pinnedIndex)
          }
          // Note to un-pin
        } else if indexPath.section == 0 {
          let noteToUnPin: Note = strongSelf.pinnedNotes[strongSelf.pinnedNotes.count - 1]
          noteToUnPin.pinned.toggle()
          print("noteToUnPin: \(noteToUnPin.title)")

          let pinnedIndex = IndexPath(row: indexPath.row, section: 0)
          let normalIndex = IndexPath(row: 0, section: 1)

          if !noteToUnPin.pinned {
            strongSelf.pinnedNotes = strongSelf.filterNotesByPinned(pin: .isPinned)
            print("new note toggled: \(noteToUnPin.pinned)")
            print("DELETE SECTIONS, # pinned notes: \(strongSelf.pinnedNotes.count)")
            tableView.moveRow(at: pinnedIndex, to: normalIndex)
            if strongSelf.pinnedNotes.count == 0 {
              strongSelf.tableSectionsAmount = 1
              tableView.deleteSections(IndexSet(arrayLiteral: 0), with: .left)
            }
          }
        }
        completion(true)
      }
      guard tableView.numberOfSections < 2 else { return }
      strongSelf.tableSectionsAmount += 1
      let newSection = IndexSet(arrayLiteral: 0)
      print("MIERDAAAAAAAAAAA")
      tableView.insertSections(newSection, with: .left)
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
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.alpha = 1
//    UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
//      cell.alpha = 1
//    })
  }
}
