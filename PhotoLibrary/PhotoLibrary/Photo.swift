//
//  Photo.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 9/01/22.
//

import UIKit

class Photo: Codable {
  var name: String
  var caption: String
  var url: String

  init(name: String, caption: String, url: String) {
    self.name = name
    self.caption = caption
    self.url = url
  }
}
