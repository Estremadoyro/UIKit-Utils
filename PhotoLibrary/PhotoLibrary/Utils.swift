//
//  Utils.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 12/01/22.
//

import UIKit

extension UITextField {
  func setLeftPadding(amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }

  func setRightPadding(amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }

  func setHorizontalPadding(amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always

    self.rightView = paddingView
    self.rightViewMode = .always
  }
}

