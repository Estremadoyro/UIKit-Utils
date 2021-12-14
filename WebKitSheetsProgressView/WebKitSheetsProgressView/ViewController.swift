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
  var progressView: UIProgressView!
  let allowedWebsites: [String] = ["lolfriends.herokuapp.com", "apple.com", "hackingwithswift.com", "google.com"]

  override func loadView() {
    webView = WKWebView()
    /// # `Delegation` -> Programming pattern
    /// # One thing acting in place of another: `Responding to events in behalf of another`
    /// # Meaning: We assign `WKWebView` a `delegate` responsible of `informing` when any `WebKit event` happens
    /// # in this case being `self` aka the current Obj.
    webView.navigationDelegate = self
    /// # If you want this `class` to be a `delegate` then you must implement `its methods`, all `WebKit's methods` are optional, so there is no need to implement them all
    /// # Having `WKNavigationDelegate` as protocol
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSettings()
    let url = URL(string: "https://\(allowedWebsites[0])")!
    /// # Give the `webView` this `url` to load
    webView.load(URLRequest(url: url))
    /// # Allow `swipping` left to right to go back or forward
    webView.allowsBackForwardNavigationGestures = true
  }

  private func navigationBarSettings() {
    /// # `navigationItem` are the `items on top`
    /// # `navigationController` is a `UINavigationView`
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openWebsiteList))
    /// # Create a `spacer` to `push` other items in the `toolbar`
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    /// # Button to `refresh` the `webView`
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    /// # Make the `toolbar` visible
    navigationController?.isToolbarHidden = false
    /// # Set the `progressView`
    progressView = UIProgressView(progressViewStyle: .default)
    /// # Take much as space as needed
    progressView.sizeToFit()
    /// # Create new `UIBarButtonItem` for the `progress view`
    /// # It takes a `customView`
    /// # The `flexibleSpace` item will make itself smaller to fit the `progressView`
    let progressButton = UIBarButtonItem(customView: progressView)
    /// # Add the items to the `toolbarItems`
    toolbarItems = [progressButton, spacer, refresh]
    /// # `webView` can give us the `estimate progress value` but the `navigationDelegate` doesn't tell us when the value has changed
    /// # Solution: `KVO` (Key Value Observing), tell me when property `X` of object `Y` gets changed by `anyone` at `anytime`
    /// # First, we need to add an `observer` to the `webView` to `observe for changes`
    /// # `observer`   -> Who the observer is?
    /// # `forKeyPath` -> What property is it gonna `observe`? It can track nested properties `#keyPath` checks if the `obj. has the property it is pointing to`
    /// # `options`    -> Which value we want?
    /// # `context`    -> Sends its value when the `observer gets called`, to check if `its the one you wanted`
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    /// # `Must` override the method `observeValue()` tells you when the `observed value` has changed
  }

  @objc private func openWebsiteList() {
    /// # Creates the `alert controller` to show an `actionSheet` with the list of websites (List of UIAlerts)
    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    /// # `handler` takes a `method` with `UIAlertAction` as `parameter`
    allowedWebsites.forEach { website in
      ac.addAction(UIAlertAction(title: website, style: .default, handler: openWebsite))
    }
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

  override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      /// # `progressView` is the `UIProgressView` view with the progres bar
      /// # `webView`      is the `WKWebView` view
    }
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      /// # Where `progressView` is the `UIProgressView` which holds the progress bar
      /// # Where `webView`      is the `WKWebView`      which holds the the current Web View
      progressView.progress = Float(webView.estimatedProgress)
    }
  }

  /// # Implement a `WKNavigationDelegate method` to check if the website is allowed
  /// # Where `webView`    -> Web view loaded
  /// # `navigationAction` -> Descriptive information about the action
  /// # `preferences`      -> Default set of `website preferences`
  /// # `decisionHandler`  -> Policy decission handler to `.allow or .cancel` the navigation
  /// # @escaping means the `decisionHandler` (closure) can be called either during `code execution` or afterwards until it `gets executed`, so it stays in memory until finally used
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    /// # The current `website url`
    let url = navigationAction.request.url
    /// # Not all the `urls` have `hosts` assigned to them
    if let host = url?.host {
      /// # `allowedWebsites.contains` fails the 2nd time, due to the `host` updating its name to `www.host.com` or sth else, that's why it's needed to check each if the changing `host` contains an `allowedWebsite` one by one, due to the `host` potentially being anywhere after reached the site
      for website in allowedWebsites {
        if host.contains(website) {
          decisionHandler(.allow)
          return
        }
      }
    }
    print("Website not allowed: \(url?.host ?? "NO_HOST_DETECTED")")
    decisionHandler(.cancel)
  }
}
