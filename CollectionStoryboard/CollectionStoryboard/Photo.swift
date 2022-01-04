//
//  Photo.swift
//  CollectionStoryboard
//
//  Created by Leonardo  on 4/01/22.
//

import Foundation

class Photo: NSObject {
  var image: String
  var name: String
  init(image: String, name: String) {
    self.image = image
    self.name = name
  }
}
