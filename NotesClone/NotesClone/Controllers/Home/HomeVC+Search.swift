//
//  HomeSearchVC.swift
//  NotesClone
//
//  Created by Leonardo  on 20/02/22.
//

import UIKit

extension HomeVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredNotes.notes = [Note]()
    print("Search text: \(searchText)")
    DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
      if searchText == "" {
        print("empty search")
        self.filteredNotes = self.notes.copy(with: nil) as? Notes ?? Notes(notes: [Note]())
      } else {
        self.notes.notes.forEach { note in
          if note.title.lowercased().contains(searchText.lowercased()) || note.body.lowercased().contains(searchText.lowercased()) {
            self.filteredNotes.notes.append(note)
          }
        }
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
