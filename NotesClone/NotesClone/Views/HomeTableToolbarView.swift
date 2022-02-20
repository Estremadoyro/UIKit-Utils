//
//  HomeTableToolbarView.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeTableToolbarView: UIToolbar {
  @IBOutlet weak var notesAmountItem: UIBarButtonItem!
  @IBOutlet weak var newNoteItem: UIBarButtonItem!

  // Can't use custom intializers when using Storyboards
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  deinit {
    print("\(self) deinited")
  }
}
