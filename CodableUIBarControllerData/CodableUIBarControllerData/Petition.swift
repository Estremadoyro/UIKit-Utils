//
//  Petition.swift
//  CodableUIBarControllerData
//
//  Created by Leonardo  on 19/12/21.
//

import Foundation

struct Petition: Codable {
  var title: String
  var body: String
  var signatureCount: Int
}
