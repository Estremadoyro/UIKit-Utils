//
//  ViewController.swift
//  MVVMPlayground
//
//  Created by Leonardo  on 17/03/22.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet private weak var activity: UIActivityIndicatorView!
  @IBOutlet private weak var tableView: UITableView!

  var viewModel = ListViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewdidload")
    configureView()
    bind()
  }

  private func configureView() {
    activity.startAnimating()
    viewModel.retrieveDataList()
  }

  private func bind() {
    viewModel.refreshData = { [weak self] in
      print("loading closure")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        self?.tableView.reloadData()
        self?.activity.stopAnimating()
        self?.activity.isHidden = true
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dataArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let listElement = viewModel.dataArray[indexPath.row]

    var content = cell.defaultContentConfiguration()
    content.text = listElement.title
    content.secondaryText = listElement.body

    cell.contentConfiguration = content
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.alpha = 0
    UIView.animate(withDuration: 0.2) {
      cell.alpha = 1
    }
  }
}
