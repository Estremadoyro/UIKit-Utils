//
//  Local.swift
//  CountriesInfo
//
//  Created by Leonardo  on 25/01/22.
//

import UIKit

class Local {
  static func loadJSON(file: String) -> Countries {
    // find file in Bundle
    guard let path = Bundle.main.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate: \(file)")
    }
    // cast to Data type
    do {
      let data = try Data(contentsOf: path)
      let decodedData = try JSONDecoder().decode(Countries.self, from: data)
      return decodedData

    } catch {
      print("Error: \(error)")
      return Countries(countries: [Country]())
    }
  }

  static func fetchImageFromURL(url: URL, updateImage: @escaping (UIImage) -> Void) {
    if let image = imageCache.object(forKey: url as NSURL) as? UIImage {
      print("image from cache")
      updateImage(image)
      return
    }
    // Its completion handler already runs in a background thread
    URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
      if let anError = error {
        debugPrint("Data task error: \(anError.localizedDescription)")
      }
      guard let aData = data, let image = UIImage(data: aData) else {
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        print("HTTP response: \(httpResponse.statusCode)")
      }
      imageCache.setObject(image, forKey: url as NSURL)
      updateImage(image)
    }).resume()
  }
}
