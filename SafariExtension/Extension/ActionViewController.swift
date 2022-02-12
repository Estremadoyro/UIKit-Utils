//
//  ActionViewController.swift
//  Extension
//
//  Created by Leonardo  on 11/02/22.
//

import MobileCoreServices
import UIKit

class ActionViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
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
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
          print(javaScriptValues)
        }
      }
    }
  }
}
