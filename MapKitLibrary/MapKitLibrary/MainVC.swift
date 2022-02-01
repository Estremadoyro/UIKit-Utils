//
//  MainVC.swift
//  MapKitLibrary
//
//  Created by Leonardo  on 1/02/22.
//

import MapKit
import UIKit

class MainVC: UIViewController {
  private let mapView: MKMapView = {
    let map = MKMapView()
    map.translatesAutoresizingMaskIntoConstraints = false
    return map
  }()
}

extension MainVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    configureSuperView()
    buildConstraints()
  }
}

extension MainVC {
  private func configureSuperView() {
//    view.overrideUserInterfaceStyle = .dark
    view.backgroundColor = UIColor.white
    title = "MapKit"
//    navigationItem.largeTitleDisplayMode = .always
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}
