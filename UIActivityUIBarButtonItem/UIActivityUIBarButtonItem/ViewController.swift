//
//  ViewController.swift
//  UIActivityUIBarButtonItem
//
//  Created by Leonardo  on 11/12/21.
//

import UIKit

class ViewController: UITableViewController {
  var pictures = [String]()
  var pictureNames = [String]()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "StormViewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
        pictureNames.append(removeSuffix(pictureName: item))
      }
    }
    pictures = sortItems()
  }

  private func removeSuffix(pictureName: String) -> String {
    return pictureName.components(separatedBy: ".")[0]
  }

  private func sortItems() -> [String] {
    return pictures.sorted(by: { $0 < $1 })
  }

  /// # Set table's # rows
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  /// # Set table's row contents
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.textProperties.color = UIColor.blue
    content.textProperties.font = .boldSystemFont(ofSize: 20)
    content.text = pictureNames[indexPath.row]
    cell.contentConfiguration = content
    return cell
  }

  /// # Set action when cell is selected
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.picturesList = pictures
      vc.currentPicture = indexPath.row + 1
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
