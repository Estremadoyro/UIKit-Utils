//
//  Person.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import Foundation

/// # `Model` for the new image selected from the `image picker`
/// # ``NSObject``: Required in order to use `NSCoding`
/// # ``NSCoding``: Coding and Decoding for archiving data)
class Person: NSObject, NSCoding {
  var name: String
  var image: String

  init(name: String, image: String) {
    self.name = name
    self.image = image
  }

  /// #``Required to conform NSCoding``

  /// # `Reading` from `archives`
  required init?(coder: NSCoder) {
    self.name = coder.decodeObject(forKey: "name") as? String ?? ""
    self.image = coder.decodeObject(forKey: "image") as? String ?? ""
  }

  /// # `Writing (Encode)` to archives
  func encode(with coder: NSCoder) {
    coder.encode(self.name, forKey: "name")
    coder.encode(self.image, forKey: "image")
  }
}
