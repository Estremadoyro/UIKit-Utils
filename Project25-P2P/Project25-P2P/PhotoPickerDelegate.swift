//
//  PhotoPickerDelegate.swift
//  Project25-P2P
//
//  Created by Leonardo  on 15/03/22.
//

import UIKit

protocol PhotoPickerDelegate: AnyObject {
  func didSelectPhoto(photo: UIImage)
}
