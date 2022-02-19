//
//  NoteCellView.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class NoteCellView: UITableViewCell {
  @IBOutlet weak var noteTitleLabel: UILabel!
  var title: String?
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    noteTitleLabel.text = title
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
