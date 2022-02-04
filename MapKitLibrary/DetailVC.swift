//
//  DetailVC.swift
//  MapKitLibrary
//
//  Created by Leonardo  on 4/02/22.
//

import UIKit
import WebKit

class DetailVC: UIViewController, WKNavigationDelegate {
  private lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    webView.layer.masksToBounds = true
    webView.layer.borderColor = UIColor.systemGray6.cgColor
    webView.layer.borderWidth = 2
    webView.layer.cornerRadius = 40
    return webView

  }()

  var placeName: String? {
    didSet {
      title = placeName
    }
  }

  deinit {
    print("\(self) deinited")
  }
}

extension DetailVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webView)
//    view.clipsToBounds = true
    buildConstraints()
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = UIColor.white
    let url = URL(string: "https://es.wikipedia.org/wiki/\(placeName ?? "Lima")")
    guard let url = url else { return }
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }
}

extension DetailVC {
  private func buildConstraints() {
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}
