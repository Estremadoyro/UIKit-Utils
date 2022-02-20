//
//  NoteCellView.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NoteCellView: UITableViewCell {
  @IBOutlet weak var noteTitleLabel: UILabel!
  var title: String? {
    didSet {
      configureTitleLabel(text: title)
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

extension NoteCellView {
  private func configureTitleLabel(text: String?) {
    guard let text = text else { return }
    noteTitleLabel.text = text
  }
}
