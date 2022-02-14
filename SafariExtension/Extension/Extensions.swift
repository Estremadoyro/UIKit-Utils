//
//  Local.swift
//  Extension
//
//  Created by Leonardo  on 13/02/22.
//

import UIKit

// Work around for geric saves
class DefaultKeys {}

extension DefaultKeys {
  static let CODE_SNIPPETS_KEY = DefaultsKey<String>(value: "code-snippets")
}

// not necessary to use generics
final class DefaultsKey<T>: DefaultKeys {
  let value: String

  init(value: String) {
    self.value = value
  }
}

// It's required to use the T (Generic) inside the function signature (Parameters or output type)
extension UserDefaults {
  func load<T: Codable>(key: DefaultsKey<String>, obj: T.Type) -> T? {
    do {
      guard let data = self.object(forKey: key.value) as? Data else { return nil }
      let loadedData = try JSONDecoder().decode(T.self, from: data)
      print("Sucessfully loaded data: \(obj.self)")
      return loadedData
    } catch {
      print("Error loading: \(T.self)")
      print(error)
      return nil
    }
  }

  func save<T: Codable>(key: DefaultsKey<String>, forObj obj: T) -> Void {
    do {
      let data = try JSONEncoder().encode(obj)
      self.set(data, forKey: key.value)
      print("Saved \(T.self)")
    } catch {
      print("Error saving: \(T.self)")
      print(error)
    }
  }
}
