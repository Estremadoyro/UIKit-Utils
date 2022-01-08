//
//  Picture.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 7/01/22.
//

import UIKit

class Picture: Codable {
  var name: String
  var image: String
  var viewCount: Int

  init(name: String, image: String, viewCount: Int) {
    self.name = name
    self.image = image
    self.viewCount = viewCount
  }
}
