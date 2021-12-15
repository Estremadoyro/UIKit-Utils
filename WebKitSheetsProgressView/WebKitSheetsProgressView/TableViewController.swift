//
//  ViewController.swift
//  WebKitSheetsProgressView
//
//  Created by Leonardo  on 12/12/21.
//

import UIKit
class TableViewController: UITableViewController {
  let allowedWebsites: [String] = ["lolfriends.herokuapp.com", "hackingwithswift.com", "google.com"]
  override func viewDidLoad() {
    title = "Websites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allowedWebsites.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = allowedWebsites[indexPath.row]
    content.textProperties.color = UIColor.purple.withAlphaComponent(0.8)
    content.textProperties.font = UIFont.systemFont(ofSize: 20)
    cell.contentConfiguration = content
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
      vc.allowedWebsites = allowedWebsites
      vc.website = allowedWebsites[indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
