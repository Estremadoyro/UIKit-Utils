//
//  ViewController.swift
//  FileManagerViewController
//
//  Created by Leonardo  on 9/12/21.
//

import UIKit

/// # `UITableViewController` is a `ViewController` for making tables
class ViewController: UITableViewController {
  var pictures = [Picture]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    /// # Loading data from UserDefaults
    loadLocalSettings()
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func loadLocalSettings() {
    LocalSettings.loadLocal(updatePictures: { [weak self] loadedPictures in
      self?.pictures = loadedPictures
    })
    DispatchQueue.main.async { [unowned self] in
      self.sortPictures()
      self.tableView.reloadData()
    }
  }

  private func sortPictures() {
    pictures.sort(by: { $0.viewCount > $1.viewCount })
  }

  private func incrementViewCount(pictureIndex: Int) {
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      let picture = strongSelf.pictures[pictureIndex]
      picture.viewCount += 1
      LocalSettings.saveLocalPictures(pictures: strongSelf.pictures)
      let indexPath = IndexPath(row: pictureIndex, section: 1)
      print("Picture: \(picture.name) views are \(picture.viewCount)")
      strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
//      strongSelf.tableView.reloadData()
    }
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
    let picture = pictures[indexPath.row]
    /// # There is `no neeed to` cast `cell` to some `custom ViewController` as it doesn't require its on properties
    /// # `iOS 14 >` on onwards
    if #available(iOS 14.0, *) {
      var content = cell.defaultContentConfiguration()
      content.text = picture.name
      content.textProperties.color = .systemIndigo
      content.textProperties.font = .boldSystemFont(ofSize: 20)
      content.secondaryText = "Views: \(picture.viewCount)"
      content.secondaryTextProperties.color = UIColor.gray.withAlphaComponent(0.8)
      cell.contentConfiguration = content
    } else {
      /// # `< iOS 14` -> `HackingWithSwift's`
      /// # Specify the `textLabel` value if exists
      cell.textLabel?.text = pictures[indexPath.row].name
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
    let picture = pictures[indexPath.row]
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
      /// # 2. Set the `DetailViewController` class' property `selectedImage` to our image name
      vc.selectedImage = picture.image
      vc.picturesCount = pictures.count
      vc.currentPicture = indexPath.row + 1
      /// # 3. Push the `DetailViewController` with id `Detail` into the navigation controller
      /// # Gets the nearest `NavigationViewController`, if any
      navigationController?.pushViewController(vc, animated: true)
    }
    picture.viewCount += 1
    sortPictures()
    print("reload")
    self.tableView.reloadData()
    LocalSettings.saveLocalPictures(pictures: pictures)
  }
}
