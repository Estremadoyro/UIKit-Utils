//
//  SnippetsListTableVC.swift
//  Extension
//
//  Created by Leonardo  on 15/02/22.
//

import UIKit

class SnippetsListTableVC: UIViewController {
  @IBOutlet var tableView: UITableView!
  weak var snippetDelegate: SnippetDelegate?

  var codeSnippets = CodeSnippets()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }

  deinit {
    print("\(self) deinited")
  }
}

extension SnippetsListTableVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SNIPPET_CELL", for: indexPath)
    var content = cell.defaultContentConfiguration()
    let snippet = codeSnippets.snippets[indexPath.row]
    content.text = snippet.title
    content.secondaryText = snippet.pageURL.host
    content.secondaryTextProperties.color = UIColor.lightGray.withAlphaComponent(0.8)
    cell.contentConfiguration = content
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.popViewController(animated: true)
    let snippet = codeSnippets.snippets[indexPath.row]
    snippetDelegate?.didSelectNewSnippet(snippetName: snippet.title, snippet: snippet.snippet)
  }
}

extension SnippetsListTableVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return codeSnippets.snippets.count
  }
}
