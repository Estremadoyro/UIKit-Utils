//
//  Local.swift
//  CountriesInfo
//
//  Created by Leonardo  on 25/01/22.
//

import Foundation

class Local {
  static func loadJSON(file: String) {
    // find file in Bundle
    guard let path = Bundle.main.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate: \(file)")
    }
    // cast to Data type
    do {
      let data = try Data(contentsOf: path)
      let decodedData = try JSONDecoder().decode(Countries.self, from: data)
      print("Decoded json data")
      decodedData.countries.forEach { country in
        print("country: \(country.name)")
      }
    } catch {
      print("Error: \(error)")
    }
  }
}
