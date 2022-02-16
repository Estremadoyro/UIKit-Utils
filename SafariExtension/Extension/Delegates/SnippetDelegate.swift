//
//  SnippetDelegate.swift
//  Extension
//
//  Created by Leonardo  on 16/02/22.
//

import UIKit

protocol SnippetDelegate: UIViewController {
  func didSelectNewSnippet(snippetName: String, snippet: String)
}
