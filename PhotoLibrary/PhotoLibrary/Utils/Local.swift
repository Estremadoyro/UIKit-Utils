//
//  Local.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 18/01/22.
//

import UIKit

class Local {
  static let LIBRARY_KEY = "library-key"
  static let emptyLibrary = Library(photos: [Photo]())

  static func writeLibrary(library: Library) {
    do {
      let encodedLibrary = try JSONEncoder().encode(library)
      UserDefaults.standard.set(encodedLibrary, forKey: LIBRARY_KEY)
      print("Successfully wrote to UserDefaults: \(library.self): \(library.photos)")
    } catch {
      print("Error encoding library: \(error)")
    }
  }

  static func readLibrary() -> Library {
    guard let data = UserDefaults.standard.object(forKey: LIBRARY_KEY) as? Data else {
      print("Error finding library with key: \(LIBRARY_KEY)")
      return emptyLibrary
    }
    do {
      let library = try JSONDecoder().decode(Library.self, from: data)
      print("Successfully read from UserDefaults: \(library.self): \(library.photos.count)")
      return library
    } catch {
      print("Error decoding library: \(error)")
      return emptyLibrary
    }
  }
}
