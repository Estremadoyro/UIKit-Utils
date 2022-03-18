//
//  Requests.swift
//  MVVMPlayground
//
//  Created by Leonardo  on 17/03/22.
//

import Foundation

struct Requests {
  static func getFullListAPI(dataList: @escaping ([List]) -> Void) {
    guard let url = URL(string: Constants.postsAPI) else { return }

    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let json = data, error == nil else { return }
      do {
        let data: [List] = try JSONDecoder().decode([List].self, from: json)
        dataList(data)
      } catch {
        print("Error fetching data: \(error)")
      }
    }.resume()
  }
}
