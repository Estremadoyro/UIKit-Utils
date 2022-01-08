//
//  LocalSettings.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 7/01/22.
//

import UIKit

class LocalSettings {
  static func loadLocalPictures(updatePictures: @escaping ([Picture]) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let localData = UserDefaults.standard.object(forKey: "pictures") as? Data else { return }
      do {
        let decodedData = try JSONDecoder().decode([Picture].self, from: localData)
        updatePictures(decodedData)
      } catch {
        print("Error decoding pictures: \(error)")
      }
    }
  }

  static func saveLocalPictures(pictures: [Picture]) {
    do {
      let data = try JSONEncoder().encode(pictures)
      UserDefaults.standard.set(data, forKey: "pictures")
      print("saved: \(pictures.map({$0.viewCount}))")
    } catch {
      print("Error encoding pictures: \(error)")
    }
  }

  static func loadPicturesFromBundle(updatePictures: @escaping ([Picture]) -> Void) {
    var pictures = [Picture]()
    DispatchQueue.global(qos: .userInteractive).async {
      /// # `FileManager`, allows to work with the `file system`
      let fm = FileManager.default
      /// # Full path name of the `Bundle's directory`
      let path = Bundle.main.resourcePath!
      /// # Gets contents of directory
      let items = try! fm.contentsOfDirectory(atPath: path)
      /// # Loop through all the `items` aka Bundle path contents
      let imageItems = items.filter { $0.hasPrefix("nssl") }
      imageItems.forEach { item in
        pictures.append(Picture(name: item.components(separatedBy: ".")[0], image: item, viewCount: 0))
      }
      LocalSettings.saveLocalPictures(pictures: pictures)
      updatePictures(pictures)
    }
  }

  static func loadLocal(updatePictures: @escaping ([Picture]) -> Void) {
    if UserDefaults.standard.value(forKey: "pictures") != nil {
      print("Loaded pictures from UserDefaults")
      LocalSettings.loadLocalPictures(updatePictures: updatePictures)
      return
    }
    print("Loaded pictures from Bundle")
    LocalSettings.loadPicturesFromBundle(updatePictures: updatePictures)
  }
}
