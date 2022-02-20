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

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    configureNavigationBar()
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
    cell.title = "Tips"
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

extension HomeTableVC: UITableViewDelegate {}
