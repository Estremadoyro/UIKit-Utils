//
//  Snippets.swift
//  Extension
//
//  Created by Leonardo  on 13/02/22.
//

import Foundation

final class Snippets {
  static let alertHelloWorld: String =
    "alert('Hello my bruddas')"

  static let alertDate: String =
    """
    var today = new Date();

    var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
    alert(date);
    """
}
