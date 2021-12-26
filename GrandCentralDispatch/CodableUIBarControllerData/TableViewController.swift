//
//  ViewController.swift
//  CodableUIBarControllerData
//
//  Created by Leonardo  on 19/12/21.
//

/// # ``UI must ONLY be executed in the MAIN THREAD``
import UIKit
class TableViewController: UITableViewController {
  var petitions = [Petition]()
  var filteredPetitions = [Petition]()
  var url: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    setAPIUrl()
    navbarSettings()
    guard let url = url else { return }
    /// # `performSelctor` does all the `CGD` work for you
//    performSelector(inBackground: #selector(fetchData), with: url)
    performSelector(onMainThread: #selector(fetchData), with: nil, waitUntilDone: false)
    fetchData(url: url)
  }

  private func setAPIUrl() {
    if navigationController?.tabBarItem.tag == 0 {
      url = "https://www.hackingwithswift.com/samples/petitions-1.json"
    }
    /// # Top rated petitions
    else if navigationController?.tabBarItem.tag == 1 {
      url = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
  }

  private func navbarSettings() {
    let creditsNavigationItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCreditsAlert))
    let filterNavigationItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitionsAlert))
    let resetNavigatoinItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilter))
    navigationItem.leftBarButtonItems = [creditsNavigationItem]
    navigationItem.rightBarButtonItems = [filterNavigationItem, resetNavigatoinItem]
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Petitions"
  }

  @objc private func resetFilter() {
    if filteredPetitions.count == petitions.count {
      return
    }
    filteredPetitions = petitions
    tableView.reloadData()
  }

  @objc private func filterPetitionsAlert() {
    let ac = UIAlertController(title: "Filter", message: "Filter petitions by keyword", preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
      if var filterKeyword = ac?.textFields?[0].text {
        filterKeyword = filterKeyword.lowercased()
        self?.filterPetitionsByKeyword(keyword: filterKeyword)
      }
    })
    present(ac, animated: true)
  }

  @objc private func showCreditsAlert() {
    let ac = UIAlertController(title: "Credits", message: "White House's We The People API", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(ac, animated: true)
  }

  private func filterPetitionsByKeyword(keyword: String) {
    guard !keyword.isEmpty else { return }
    filteredPetitions = petitions.filter { $0.title.lowercased().contains(keyword) }
    tableView.reloadData()
  }

  private func fetchData(url: String) {
    /// # Doing `url fetching` in `viewDidLoad` is not the best, as it will freeze the view until the data is retrieved
    /// # 1. Request the data, fails if the `url` is `incorrect` (Doesn't exist)
    if let url = URL(string: url) {
      /// # 2. Cast data to `Data Type`
      /// # ``this call, is BLOCKING the UI from rendering (Running on main thread)``
      /// # Code that is `asynchronous` or that can be run in parallel, should be run in a `different thread` ``Multi-Threading``
      /// # Assign the code to a `QoS queue`
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        if let data = try? Data(contentsOf: url) {
          self?.parseData(json: data)
          return
        }
        /// # Must be executed in the `Async Background Thread` in order to work properly, otherwise, it will `show an alert` regardess of the API Req. result
        self?.apiError()
      }
    }
  }

  private func parseData(json: Data) {
    /// # Set the decoder
    let decoder = JSONDecoder() /// # ``Converts from JSON to Codable objects"
    /// # Decode the `Data Type` into the `Petitions Type` defined
    /// # It's `ok` to `parse JSON` in a `background thread`
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      /// # Set the `petitions property` to the `decoded Petitions data type`
      petitions = jsonPetitions.results
      filteredPetitions = petitions
      /// # Reload the table
      /// # It is `NEVER OK` to do `UI` work on a `background thread`
      /// # ``Back to the Main Thread`` for UI work
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }

  private func apiError() {
    /// # As this is `UI` work, it `must` be executed in the `Main Thread`
    DispatchQueue.main.async { [weak self] in
      let ac = UIAlertController(title: "API Error", message: "There was a problem requesting the data from the server", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      self?.present(ac, animated: true)
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    let petition = filteredPetitions[indexPath.row]
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
    detailVC.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(detailVC, animated: true)
  }

  /// # Animation???
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
    UIView.animate(withDuration: 0.9, animations: {
      cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
    })
  }
}
