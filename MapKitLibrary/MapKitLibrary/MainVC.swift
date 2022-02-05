//
//  MainVC.swift
//  MapKitLibrary
//
//  Created by Leonardo  on 1/02/22.
//

import MapKit
import UIKit

class MainVC: UIViewController {
  private var detailVC: DetailVC?

  private let mapTypes: [(name: String, map: MKMapType)] = [("Satellital", .satellite), ("Standard", .standard), ("Hybrid", .hybrid)]
  private let mapView: MKMapView = {
    let map = MKMapView()
    map.translatesAutoresizingMaskIntoConstraints = false
    map.mapType = .mutedStandard
    map.layer.borderColor = UIColor.systemGray6.withAlphaComponent(0.8).cgColor
    map.layer.borderWidth = 2
    map.layer.cornerRadius = 40
    return map
  }()
}

extension MainVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    mapView.delegate = self
    configureSuperView()
    buildConstraints()
    buildAnnotations()
  }
}

extension MainVC {
  private func configureSuperView() {
//    view.overrideUserInterfaceStyle = .dark
    view.backgroundColor = UIColor.white
    title = "MapKit"
    let configureBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(changeMap))
    navigationItem.rightBarButtonItems = [configureBtn]
    navigationItem.largeTitleDisplayMode = .automatic
  }

  private func buildConstraints() {
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}

extension MainVC {
  private func buildAnnotations() {
    let lima = Capital(title: "Lima", coordinate: CLLocationCoordinate2D(latitude: -12.04318, longitude: -77.02824), info: "La fe es lo mas lindo de la vida")
    let tokyo = Capital(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6804, longitude: 139.7690), info: "Manga")
    mapView.addAnnotations([lima, tokyo])
  }
}

extension MainVC: MKMapViewDelegate {
  // View from the associated annotation
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Only show view for Capital annotation types
    print("wakanda foreva")
    guard annotation is Capital else { return nil }
    // annotation view id
    let identifier = "Capital"
    // dequeue annotation view if available
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

    // create a new annotation view as none were available for dequeuing
    if annotationView == nil {
      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      // create btn inside view
      let btn = UIButton(type: .detailDisclosure)
      // if btn is subclass of UIControl, then the delegate will inform of taps (aka addTarget not needed)
      annotationView?.rightCalloutAccessoryView = btn
    } else {
      // update dequeued annotation view
      annotationView?.annotation = annotation
    }
    annotationView?.markerTintColor = UIColor.systemPurple
    return annotationView
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // Cast the annotation view as a Capital
    guard let annotation = view.annotation as? Capital else { return }
    let placeName = annotation.title
//    let placeInfo = annotation.info

    // show AC when .detailDisclosure btn is tapped
//    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//    ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//    present(ac, animated: true)

    // push webview
    detailVC = DetailVC()
    guard let detailVC = self.detailVC else { return }
    detailVC.placeName = placeName
    navigationController?.pushViewController(detailVC, animated: true)
    self.detailVC = nil
  }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return mapTypes.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return mapTypes[row].name
  }

  @objc
  private func changeMap() {
    let vc = UIViewController()
    vc.preferredContentSize = CGSize(width: 250, height: 100)
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: -80, width: 250, height: 200))
    pickerView.delegate = self
    pickerView.dataSource = self
    vc.view.addSubview(pickerView)
    let ac = UIAlertController(title: "Map Style", message: nil, preferredStyle: .alert)
    ac.setValue(vc, forKey: "contentViewController")
    ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
      let mapType = pickerView.selectedRow(inComponent: 0)
      let map = self?.mapTypes[mapType]
      guard let map = map else { return }
      print(map.name)
      self?.mapView.mapType = map.map
    }))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(ac, animated: true, completion: nil)
  }
}
