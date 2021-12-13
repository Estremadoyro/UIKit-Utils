//
//  ViewController.swift
//  WebKitSheetsProgressView
//
//  Created by Leonardo  on 12/12/21.
//

import UIKit
import WebKit

/// # Swift needs to know all the methods of `WKWebView's delegate` need to implement (Come in a Protocol)
/// # `ViewController` inherits from `UIViewController (Class)`, but `WKNavigationDelegate (Protoocl)` is actually a `promise` of implementing all of its methods
/// # The `SuperClass` (UIViewController) comes first, then the `Protocols` (WKNavigationDelegate)
class ViewController: UIViewController, WKNavigationDelegate {
  /// # `Implicity Unwrapped` optional, it `might be nil` but Swift eliminates the need for unwrapping. It doesn't matter if has no value assigned, as it will default to `nil`
  var webView: WKWebView!

  override func loadView() {
    webView = WKWebView()
    /// # `Delegation` -> Programming pattern
    /// # One thing acting in place of another: `Responding to events in behalf of another`
    /// # Meaning: We assign `WKWebView` a `delegate` responsible of `informing` when any `WebKit event` happens
    /// # in this case being `self` aka the current Obj.
    webView.navigationDelegate = self
    /// # If you want this `class` to be a `delegate` then you must implement `its methods`, all `WebKit's methods` are optional, so there is no need to implement them all
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSettings()
    let url = URL(string: "https://lolfriends.herokuapp.com")!
    /// # Give the `webView` this `url` to load
    webView.load(URLRequest(url: url))
    /// # Allow `swipping` left to right to go back or forward
    webView.allowsBackForwardNavigationGestures = true
  }

  private func navigationBarSettings() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openWebsiteList))
  }

  @objc private func openWebsiteList() {
    /// # Creates the `alert controller` to show an `actionSheet` with the list of websites (List of UIAlerts)
    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    /// # `handler` takes a `method` with `UIAlertAction` as `parameter`
    ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openWebsite))
    ac.addAction(UIAlertAction(title: "instagram.com", style: .default, handler: openWebsite))
    ac.addAction(UIAlertAction(title: "lolfriends.herokuapp.com", style: .default, handler: openWebsite))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(ac, animated: true, completion: nil)
  }

  /// # Takes the `UIAlertAction` necessary by the `handler`
  @objc private func openWebsite(action: UIAlertAction) {
    let url = URL(string: "https://\(action.title!)")!
    webView.load(URLRequest(url: url))
  }

  /// # The protocol `WKNavigationDelegate` comes with its own `default implemented methods`
  /// # `didFinish` runs when the `web view` has loaded
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
}
