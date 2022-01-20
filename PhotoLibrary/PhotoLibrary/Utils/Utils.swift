//
//  Utils.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 12/01/22.
//

import UIKit

extension UIView {
  func addShadowAndCorners(fillColor: CGColor, cornerRadius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) -> CAShapeLayer {
    let shadowLayer = CAShapeLayer()
    shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    shadowLayer.fillColor = fillColor
    shadowLayer.shadowColor = shadowColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = shadowOffset
    shadowLayer.shadowOpacity = shadowOpacity
    shadowLayer.shadowRadius = shadowRadius
    return shadowLayer
  }
}

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

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }

//  mutating func capitalizeFirstLetter() {
//    self = self.capitalizingFirstLetter()
//  }
}
