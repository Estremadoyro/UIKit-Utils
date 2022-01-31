//
//  ViewController.swift
//  CountriesInfo
//
//  Created by Leonardo  on 24/01/22.
//

import UIKit

class TableVC: UIViewController {
  private lazy var countries = Countries()
  private var detailVC: DetailVC?

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CountryCellView.self, forCellReuseIdentifier: "\(CountryCellView.self)")
    tableView.separatorStyle = .none
    tableView.rowHeight = 100.0
//    tableView.backgroundColor = UIColor.systemGray6
    tableView.backgroundColor = UIColor.white
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if isBeingPresented || isMovingToParent {
      let visibleCells = tableView.visibleCells
      let invisibleCells: [UITableViewCell] = visibleCells.map { $0.alpha = 0; return $0 }

      invisibleCells.enumerated().forEach { index, invisibleCell in
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), options: [], animations: {
          invisibleCell.alpha = 1
        })
      }
    }
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
//    view.backgroundColor = UIColor.systemGray6
    view.backgroundColor = UIColor.white
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
}

extension TableVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Calls the init(style, reuseIdentifier) when dequeing, or call reuse if there was an existing cell available
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CountryCellView.self)") as? CountryCellView else {
      fatalError("Error dequeuing cell")
    }

    let country = countries.countries[indexPath.row]
    Local.fetchImageFromURL(url: country.flag, updateImage: { fetchedImage in
      cell.countryFlagImage = fetchedImage
    })
    cell.country = country
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.countries.count
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // animate
    if indexPath.row > countries.countries.count - 4 {
      let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -100, 0)
      cell.layer.transform = rotationTransform
      cell.alpha = 0.0
      UIView.animate(withDuration: 0.5, animations: {
        cell.layer.transform = CATransform3DIdentity
        cell.alpha = 1
      })
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let country = countries.countries[indexPath.row]
    guard let currentCell = tableView.cellForRow(at: indexPath) as? CountryCellView else { return }
    detailVC = DetailVC(country: country, flagImage: currentCell.countryFlagImage)
    guard let detailVC = detailVC else { return }
    navigationController?.pushViewController(detailVC, animated: true)
    self.detailVC = nil
  }
}
