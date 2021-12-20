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
    let html = """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style> body { font-size: 150%; background-color: #000; color: #fff }</style>
    </head>
    <body>
    <h2>\(detailItem.title)</h2>
    \(detailItem.body)
    </body>
    </html>
    """
    /// # Load `local HTML` in the `WKWebView`
    webView.loadHTMLString(html, baseURL: nil)
  }
}
