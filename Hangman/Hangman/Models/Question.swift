//
//  Question.swift
//  Hangman
//
//  Created by Leonardo  on 27/12/21.
//

import Foundation

class Question {
  var word: String
  var letters: Int

  init(word: String, letters: Int) {
    self.word = word
    self.letters = letters
  }
}
