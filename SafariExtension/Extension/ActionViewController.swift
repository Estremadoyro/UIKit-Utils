//
//  ActionViewController.swift
//  Extension
//
//  Created by Leonardo  on 11/02/22.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // extensionContext -> how the extension interacts with the app
    // Get items (NSExtensionItem) the app is sending to the extension
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      // Get the first attachtment from the item attachments
      if let itemProvider = inputItem.attachments?.first {
        // Provide the actual inputItem
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { _, _ in
        }
      }
    }
  }
}
