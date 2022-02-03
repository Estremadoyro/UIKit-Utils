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
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

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
    return annotationView
  }
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // Cast the annotation view as a Capital
    guard let annotation = view.annotation as? Capital else { return }
    let placeName = annotation.title
    let placeInfo = annotation.info
    
    // show AC when .detailDisclosure btn is tapped
    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
    present(ac, animated: true)
  }
}
