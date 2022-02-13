//
//  ActionViewController.swift
//  Extension
//
//  Created by Leonardo  on 11/02/22.
//

import MobileCoreServices
import UIKit

class ActionViewController: UIViewController {
  @IBOutlet var script: UITextView!

  var pageTitle: String = ""
  var pageURL: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemPink
    handleKeyboardNotifications()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    // extensionContext -> how the extension interacts with the app
    // Get items (NSExtensionItem) the app is sending to the extension
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      // Get the first attachtment from the item attachments
      if let itemProvider = inputItem.attachments?.first {
        // Data recieved from the extension, could be anything Apple wants
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, _ in
          // Parse the extension data to an NSDictionary
          guard let itemDictionary = dict as? NSDictionary else { return }
          // Dict from Target.js, so you can get data from unique Keys
          // Values to pass to the run method in Action.js
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
          self?.pageTitle = javaScriptValues["title"] as? String ?? ""
          self?.pageURL = javaScriptValues["URL"] as? String ?? ""

          DispatchQueue.main.async {
            self?.title = self?.pageTitle
          }
        }
      }
    }
  }
}

extension ActionViewController {
  @objc
  private func done() {
    // the same as getting the extension items, but in reverse, now providing from the extension to the app
    let item = NSExtensionItem()
    let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
    // values to pass to the finalize method in Action.js
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
    let customJavaScrpint = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
    item.attachments = [customJavaScrpint]

    extensionContext?.completeRequest(returningItems: [item])
  }
}

extension ActionViewController {
  private func handleKeyboardNotifications() {
    let notificationCenter = NotificationCenter.default
    // object: nil -> Don't care who sends the notification
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  @objc
  private func adjustForKeyboard(notification: Notification) {
    // get keyboard dimensions (frame), are sent as NSValue but contains a CGRect and CGPoint & CGSize inside of it
    // userInfo: [AnyHashable: Any] needs to cast its Key's value
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    // frame (CGRect)
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    // convert the CGRect to the view coordinates so it can handle both Portrait & Landscape mode
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)

    // Insetting the bottom of the UITextView with the Height of the Keyboard, so it has the impression the Keyboard is following the text. When in reality it only has bottom insets the height of the Keyboard

    /// # ``From iPhone X and on (Have notch)``, there is a `safe area`
    /// # The bottom insets will start from the `Bottom Safe Area height`, hence, the `insert height` will have the `Keyboard's height + safe area bottom (Since it starts from there)`
    // Solution: Account for the Bottom Safe Area Insets by removin them from the keyboard's height
    script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    script.scrollIndicatorInsets = script.contentInset

    // selectedRange = Visible part of the UITextView (Until the cursor's location)
    let selectedRange = script.selectedRange
    // Scroll so the Selected Range is always visible
    script.scrollRangeToVisible(selectedRange)
  }
}
