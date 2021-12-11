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

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
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
        pictures.append(item)
      }
    }

    print(pictures)
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
    /// # `iOS 14 >` on onwards
    if #available(iOS 14.0, *) {
      var content = cell.defaultContentConfiguration()
      content.text = self.pictures[indexPath.row]
      cell.contentConfiguration = content
    } else {
      /// # `< iOS 14` -> `HackingWithSwift's`
      /// # Specify the `textLabel` value if exists
      cell.textLabel?.text = pictures[indexPath.row]
    }
    return cell
  }

  /// # Load the `DatailViewController` created, from storyboard
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    /// # 1. Try loading the `Detail` view controller (Storyboard ViewController) and typecasting it to DetailViewController (`CocoaTouch` file created)
    /// # basically leting the code know it came from a story board and use it
    /// # `storyboard` the Storyboard from which the ViewController originated
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      /// # 2. Set the `DetailViewController` class' property `selectedImage` to our image name
      vc.selectedImage = pictures[indexPath.row]
      /// # 3. Push the `DetailViewController` with id `Detail` into the navigation controller
      /// # Gets the nearest `NavigationViewController`, if any
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
