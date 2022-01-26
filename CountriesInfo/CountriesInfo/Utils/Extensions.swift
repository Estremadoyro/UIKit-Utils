//
//  Extensions.swift
//  CountriesInfo
//
//  Created by Leonardo  on 26/01/22.
//

import UIKit

extension String {
  func capitalizingFirstLetter() -> String {
    return self.prefix(1).capitalized + self.dropFirst()
  }

  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
