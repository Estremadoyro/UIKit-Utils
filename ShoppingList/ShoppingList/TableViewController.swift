//
//  ViewController.swift
//  ShoppingList
//
//  Created by Leonardo  on 19/12/21.
//

import UIKit

final class TableViewController: UITableViewController {
  var products = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navbarSettings()
    navBarItems()
    products.append("Dr Stone, Vol. 24")
  }

  private func navbarSettings() {
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Mangakasa"
  }

  private func navBarItems() {
    let addNavigationItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItemAlert))
    let shareNavigationItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
    let clearNavigationItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearShoppingList))

    navigationItem.rightBarButtonItems = [addNavigationItem, shareNavigationItem]
    navigationItem.leftBarButtonItem = clearNavigationItem
  }

  @objc private func shareShoppingList() {
    let products = products.joined(separator: "\n")
    let ac = UIActivityViewController(activityItems: [products], applicationActivities: nil)
    present(ac, animated: true)
  }

  @objc private func clearShoppingList() {
    products.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }

  private func addProductsToTable(product: String) {
    guard !product.isEmpty else {
      print("product is emtpy")
      return
    }
    /// # Append product at `position 0`
    products.insert(product, at: 0)
    /// # Table's `first cell (row: 0)` and first section
    let indexPath = IndexPath(row: 0, section: 0)
    /// # Insert `product` in `table`
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  @objc private func addNewItemAlert() {
    let ac = UIAlertController(title: "New product", message: "Please add a new product", preferredStyle: .alert)
    ac.addTextField()
    /// # Prevent strong reference cycle
    ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
      guard let productName = ac?.textFields?[0].text else {
        self?.products = []
        return
      }
      /// # Insert `product` in table
      self?.addProductsToTable(product: productName)
    })
    present(ac, animated: true)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = products[indexPath.row]
    content.textProperties.color = UIColor.systemBlue.withAlphaComponent(0.70)
    content.textProperties.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
    cell.contentConfiguration = content
    return cell
  }

  /// # Removes the `effect of selecting an element`
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}
