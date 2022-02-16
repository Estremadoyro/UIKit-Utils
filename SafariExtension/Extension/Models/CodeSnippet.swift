//
//  CodeSnippet.swift
//  Extension
//
//  Created by Leonardo  on 13/02/22.
//

import UIKit

class CodeSnippet: Codable {
  var uuid = UUID()
  var title: String
  var snippet: String
  var pageURL: URL

  init(title: String, snippet: String?, pageURL: URL?) {
    self.title = title
    self.snippet = snippet ?? "// Failed saving snippet"
    self.pageURL = pageURL ?? URL(string: "https://www.apple.com")!
  }
}

class CodeSnippets: Codable {
  var snippets: [CodeSnippet] {
    didSet {
      print("didSet")
      UserDefaults.standard.save(key: .CODE_SNIPPETS_KEY, forObj: self)
    }
  }

  init(snippets: [CodeSnippet]) {
    self.snippets = snippets
  }

  init() {
    self.snippets = UserDefaults.standard.load(key: .CODE_SNIPPETS_KEY, obj: CodeSnippets.self)?.snippets ?? [CodeSnippet]()
    self.snippets.forEach { snippet in
      print("Loaded: \(snippet.snippet) from \(snippet.pageURL.host ?? "No host")")
    }
  }
}
