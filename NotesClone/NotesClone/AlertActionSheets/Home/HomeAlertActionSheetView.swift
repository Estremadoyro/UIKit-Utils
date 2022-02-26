//
//  HomeAlertActionSheetView.swift
//  NotesClone
//
//  Created by Leonardo  on 25/02/22.
//

import UIKit

class HomeAlertActionSheetView: UIView {}

@IBDesignable extension HomeAlertActionSheetView {
  @IBInspectable var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = (newValue > 0)
    }
  }
}
