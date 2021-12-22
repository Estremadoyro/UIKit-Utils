//
//  DetailsViewController.swift
//  CodableUIBarControllerData
//
//  Created by Leonardo  on 19/12/21.
//

import UIKit
import WebKit

/// # ``This VC has no Storyboard``
class DetailViewController: UIViewController {
  var webView: WKWebView!
  var detailItem: Petition?

  override func loadView() {
    webView = WKWebView()
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    /// # Get `Petition`
    guard let detailItem = detailItem else { return }
    /// # `HTML` snippet
    let html = generateHTML(petition: detailItem)
    navigationBarSettings(petition: detailItem)
    /// # Load `local HTML` in the `WKWebView`
    webView.loadHTMLString(html, baseURL: nil)
  }

  private func navigationBarSettings(petition: Petition) {
    let shareNavigationItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePetition))
    title = petition.title
    navigationItem.rightBarButtonItems = [shareNavigationItem]
    navigationItem.largeTitleDisplayMode = .never
  }

  @objc private func sharePetition() {
    guard let petition = detailItem else { return }
    let ac = UIActivityViewController(activityItems: [petition.title, petition.body], applicationActivities: nil)
    present(ac, animated: true, completion: nil)
  }

  private func generateHTML(petition: Petition) -> String {
    return """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style> body { font-size: 150%; background-color: #fff; color: #000; margin-left: 20px; margin-right: 20px }</style>
    </head>
    <body>
    <h2>\(petition.title)</h2>
    \(petition.body)
    </body>
    </html>
    """
  }
}
