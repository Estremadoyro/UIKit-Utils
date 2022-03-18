//
//  ListViewModel.swift
//  MVVMPlayground
//
//  Created by Leonardo  on 17/03/22.
//

import Foundation

// View -> ViewModel
// View <- ViewModel
class ListViewModel {
  // Create a method to connect the View with the ViewModel
  var refreshData: () -> Void = {}

  // Data Source (Array<List>)
  var dataArray = [List]() {
    didSet {
      refreshData()
    }
  }

  /// # Connection Service
  // Fetch the API with a GET request
  func retrieveDataList() {
    Requests.getFullListAPI(dataList: { [weak self] requestedData in
      self?.dataArray = requestedData
    })
  }
}
