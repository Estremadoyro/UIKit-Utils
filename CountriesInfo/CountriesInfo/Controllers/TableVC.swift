//
//  ViewController.swift
//  CountriesInfo
//
//  Created by Leonardo  on 24/01/22.
//

import UIKit

class TableVC: UIViewController {
  private lazy var countries = Countries()
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CountryCellView.self, forCellReuseIdentifier: "\(CountryCellView.self)")
    tableView.rowHeight = 80.0
//    tableView.layer.borderColor = UIColor.systemPink.cgColor
//    tableView.layer.borderWidth = 2
    return tableView
  }()
}

extension TableVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
    buildSubViews()
    buildConstraints()
  }
}

extension TableVC {
  private func buildSubViews() {
    view.addSubview(tableView)
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}

extension TableVC {
  private func setupVC() {
    title = "Countries"
    view.backgroundColor = UIColor.white
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
}

extension TableVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Calls the init(style, reuseIdentifier) when dequeing, or call reuse if there was an existing cell available
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CountryCellView.self)") as? CountryCellView else {
      fatalError("Error dequeing cell")
    }
    let country = countries.countries[indexPath.row]
    cell.country = country
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.countries.count
  }
}
