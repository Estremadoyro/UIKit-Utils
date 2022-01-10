//
//  PhotoPickerDelegate.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 9/01/22.
//

import UIKit

protocol PhotoPickerDelegate: AnyObject {
  func didSelectPhoto(image: UIImage)
}
