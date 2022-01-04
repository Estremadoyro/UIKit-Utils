//
//  ViewController.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 9/12/21.
//

import UIKit

/// # `UITableViewController` is a `ViewController` for making tables
class ViewController: UITableViewController {
  var pictures = [String]()
  var pictureNames = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    loadImagesFromBundle()
  }

  func loadImagesFromBundle() {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let strongSelf = self else { return }
      /// # `FileManager`, allows to work with the `file system`
      let fm = FileManager.default
      /// # Full path name of the `Bundle's directory`
      let path = Bundle.main.resourcePath!
      /// # Gets contents of directory
      let items = try! fm.contentsOfDirectory(atPath: path)
      /// # Loop through all the `items` aka Bundle path contents
      for item in items {
        if item.hasPrefix("nssl") {
          // this is the picture to load
          /// # remove the `.type`
          strongSelf.pictures.append(item)
          strongSelf.pictureNames.append(strongSelf.removeSuffix(pictureName: item))
        }
      }
      strongSelf.pictures = strongSelf.sortItems()
      print(strongSelf.pictures)
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }

  private func removeSuffix(pictureName: String) -> String {
    return pictureName.components(separatedBy: ".")[0]
  }

  private func sortItems() -> [String] {
    return pictures.sorted(by: { $0 < $1 })
  }

  /// # Define the `number of rows` of the table
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  /// # Define the `contents of each row` and how it should look like
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /// # Cells in a table are `recycled` meaning the cells rendered on screen are then `rehused` by other cells
    /// # that don't fit in the screen
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    /// # There is `no neeed to` cast `cell` to some `custom ViewController` as it doesn't require its on properties
    /// # `iOS 14 >` on onwards
    if #available(iOS 14.0, *) {
      var content = cell.defaultContentConfiguration()
      content.text = self.pictureNames[indexPath.row]
      content.textProperties.color = .systemIndigo
      content.textProperties.font = .boldSystemFont(ofSize: 20)
      cell.contentConfiguration = content
    } else {
      /// # `< iOS 14` -> `HackingWithSwift's`
      /// # Specify the `textLabel` value if exists
      cell.textLabel?.text = pictures[indexPath.row]
      cell.textLabel?.font = .boldSystemFont(ofSize: 20)
      cell.textLabel?.textColor = .systemIndigo
    }
    return cell
  }

  /// # Load the `DatailViewController` created, from storyboard
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    /// # 1. Try loading the `Detail` view controller (Storyboard ViewController) and typecasting it to DetailViewController (`CocoaTouch` file created)
    /// # basically leting the code know it came from a story board and use it
    /// # `storyboard` the Storyboard from which the ViewController originated
    /// # Most importantly, to `customize` the `ViewController`, which properties need to be accessed `safely aka unwrapped`
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      /// # 2. Set the `DetailViewController` class' property `selectedImage` to our image name
      vc.selectedImage = pictures[indexPath.row]
      vc.picturesList = pictures
      vc.currentPicture = indexPath.row + 1
      /// # 3. Push the `DetailViewController` with id `Detail` into the navigation controller
      /// # Gets the nearest `NavigationViewController`, if any
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
