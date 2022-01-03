//
//  Utils.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import UIKit

public extension UIView {
  func createCustomBorderRadius(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
