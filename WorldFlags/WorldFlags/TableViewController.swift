//
//  ViewController.swift
//  WorldFlags
//
//  Created by Leonardo  on 12/12/21.
//

import UIKit

class TableViewController: UITableViewController {
  var countries: [String] = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationSettings()
    /// # View's `background color`
    view.backgroundColor = UIColor.black
  }

  private func setNavigationSettings() {
    title = "Flags"
    navigationController?.navigationBar.prefersLargeTitles = true
    /// # Change `navigation title color`
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationController?.navigationBar.barStyle = UIBarStyle.black
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = countries[indexPath.row].uppercased()
    content.textProperties.color = UIColor.white.withAlphaComponent(0.8)
    content.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
    cell.contentConfiguration = content
    cell.backgroundColor = UIColor.black
    /// # Cell's border color
//    cell.layer.borderColor = UIColor.white.cgColor
//    cell.layer.borderWidth = 0.4
    /// # Background color when `cell is selected`
    let bgColorView = UIView()
    bgColorView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
    cell.selectedBackgroundView = bgColorView
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("row selected: \(indexPath.row)")
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Flag") as? FlagViewController {
      vc.flag = countries[indexPath.row]
      print("Cell selected: \(countries[indexPath.row])")
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
