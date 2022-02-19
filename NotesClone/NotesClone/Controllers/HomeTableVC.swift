//
//  ViewController.swift
//  NotesClone
//
//  Created by Leonardo  on 18/02/22.
//

import UIKit

class HomeTableVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let NOTES_CELL_ID = "NOTES_CELL"
  private lazy var homeTableNavigationBar = HomeTableNavigationBar(homeTableVC: self)
  private lazy var homeTableView = HomeTableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    homeTableView.dataSource = self
    homeTableView.delegate = self
    homeTableView.register(NoteCellView.self, forCellReuseIdentifier: NOTES_CELL_ID)
  }
}

extension HomeTableVC {
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    homeTableNavigationBar.buildNavigationBarItems()
  }
}

extension HomeTableVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NOTES_CELL_ID, for: indexPath) as? NoteCellView else {
      fatalError("Error dequeing \(NOTES_CELL_ID)")
    }
    cell.title = "Dr Stone"
    print(cell)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}

extension HomeTableVC: UITableViewDelegate {}
