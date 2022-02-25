//
//  HomeSearchVC.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

extension HomeVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("Search text: \(searchText)")
    let auxNotes = filteredNotes
    print("[Filtered] 1. \(filteredNotes.count)")
    print("[Aux] 1. \(auxNotes.count)")
    filteredNotes = [Note]()

    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
      if searchText == "" {
        print("empty search")
        print("[Filtered] 3. \(filteredNotes.count)")
        print("[Aux] 3. \(auxNotes.count)")
        self.filteredNotes = notes.notes
      } else {
        self.notes.notes.forEach { note in
          if note.title.lowercased().contains(searchText.lowercased()) || note.body.lowercased().contains(searchText.lowercased()) {
            self.filteredNotes.append(note)
          }
        }
        print("[Filtered] 2. \(filteredNotes.count)")
        print("[Aux] 2. \(auxNotes.count)")
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

extension HomeVC {
  func configureGestures() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarDismissKeyboardTouchOutside))
    gestureRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(gestureRecognizer)
  }

  @objc
  private func searchBarDismissKeyboardTouchOutside() {
    homeSearchBar.endEditing(true)
  }
}
