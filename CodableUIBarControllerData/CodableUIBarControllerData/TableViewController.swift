//
//  ViewController.swift
//  CodableUIBarControllerData
//
//  Created by Leonardo  on 19/12/21.
//

import UIKit
class TableViewController: UITableViewController {
  var petitions = [Petition]()
  let url = "https://www.hackingwithswift.com/samples/petitions-1.json"

  override func viewDidLoad() {
    super.viewDidLoad()
    navbarSettings()
    fetchData(url: url)
  }

  private func navbarSettings() {
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Petitions"
  }

  private func fetchData(url: String) {
    /// # Doing `url fetching` in `viewDidLoad` is not the best, as it will freeze the view until the data is retrieved
    let urlString = url
    /// # 1. Request the data
    if let url = URL(string: urlString) {
      /// # 2. Cast data to `Data Type`
      if let data = try? Data(contentsOf: url) {
        parseData(json: data)
      }
    }
  }

  private func parseData(json: Data) {
    /// # Set the decoder
    let decoder = JSONDecoder() /// # ``Converts from JSON to Codable objects"
    /// # Decode the `Data Type` into the `Petitions Type` defined
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      /// # Set the `petitions property` to the `decoded Petitions data type`
      petitions = jsonPetitions.results
      /// # Reload the table
      tableView.reloadData()
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return petitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    let petition = petitions[indexPath.row]
    content.text = petition.title
    content.textProperties.font = UIFont.boldSystemFont(ofSize: 19)
    /// # Make cell text wrap
    content.textProperties.numberOfLines = 1
    content.textProperties.lineBreakMode = .byWordWrapping
    content.secondaryTextProperties.numberOfLines = 1
    content.secondaryTextProperties.lineBreakMode = .byWordWrapping
    /// # Text `underneath` the title
    content.secondaryText = petition.body
    cell.contentConfiguration = content
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailVC = DetailViewController()
    detailVC.detailItem = petitions[indexPath.row]
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
