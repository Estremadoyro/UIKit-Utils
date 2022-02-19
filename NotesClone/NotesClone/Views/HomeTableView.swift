//
//  HomeTableView.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class HomeTableView: UITableView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.systemBlue
  }
}
