//
//  MainViewDelegate.swift
//  Hangman
//
//  Created by Leonardo  on 30/12/21.
//

import Foundation
import UIKit

protocol MainViewDelegate: AnyObject {
  func buttonPressed(_ sender: UIButton)
  var wordPlaceholder: String { get set }
  var wordLetters: Int { get set }
  var lifes: Int { get set }
  var orientation: UIDeviceOrientation { get }
}
