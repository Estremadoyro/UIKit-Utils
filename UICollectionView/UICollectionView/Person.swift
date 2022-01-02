//
//  Person.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import Foundation

/// # `Model` for the new image selected from the `image picker`
class Person {
  var name: String
  var image: String

  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
