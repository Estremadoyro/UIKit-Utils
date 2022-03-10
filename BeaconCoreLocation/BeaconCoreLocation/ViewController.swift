//
//  ViewController.swift
//  BeaconCoreLocation
//
//  Created by Leonardo  on 9/03/22.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {
  @IBOutlet private weak var distanceReading: UILabel!
  @IBOutlet private weak var beaconNameLabel: UILabel!
  @IBOutlet private weak var ditanceCircleView: UIView!

  var locationManager: CLLocationManager?
  var beaconDetected: CLBeacon? {
    didSet {
      configureDetectedBeacon(beacon: beaconDetected)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
    view.backgroundColor = UIColor.systemGray
    ditanceCircleView.transform = CGAffineTransform(scaleX: 0.0, y: 0)
  }
}

extension ViewController: CLLocationManagerDelegate {
  private func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    // grant permission
    locationManager?.requestAlwaysAuthorization()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    // Did user authorize to run always, it must authorize.
    if status == .authorizedAlways {
      // Is Beacon monitoring funcinoality available in the device?
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        // Is ranging available in the device?
        if CLLocationManager.isRangingAvailable() {
          // stuff
          print("User authorized")
          registerBeacons()
        }
      }
    }
  }
}

extension ViewController {
  private func registerBeacons() {
    print("BEACONS REGISTERED")
    // This UUID is one of the preset in the Beacon Locate app, used to moc a Beacon
    let beacon1UUID: String = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
    let beacon2UUID: String = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
    let beacon3UUID: String = "74278BDA-B644-4520-8F0C-720EAF059935"
    let beaconUUIDs: [String] = [beacon1UUID, beacon2UUID, beacon3UUID]
    for (i, beaconUUID) in beaconUUIDs.enumerated() {
      monitorBeacon(uuid: UUID(uuidString: beaconUUID)!, identififer: "Beacon\(i)")
    }
//    monitorBeacon(uuid: UUID(uuidString: beacon2UUID)!, identififer: "Beacon2")
  }

  private func monitorBeacon(uuid: UUID, identififer: String) {
    // Where the major and minor are used to devide de uuid into others, to add precision
    let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
    // Set the region and the beacon Id
    let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: identififer)
    // Start monitor and ranging
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(satisfying: beaconConstraint)
  }

  private func startScanning() {
    // This UUID is one of the preset in the Beacon Locate app, used to moc a Beacon
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    // Where the major and minor are used to devide de uuid into others, to add precision
    let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
    // Set the region and the beacon Id
    let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint, identifier: "MyBeacon")
    // Start monitor and ranging
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(satisfying: beaconConstraint)
  }

  private func update(distance: CLProximity) {
    UIView.animate(withDuration: 1) {
      switch distance {
        case .far:
          self.view.backgroundColor = UIColor.systemBlue
          self.distanceReading.text = "FAR"
          self.ditanceCircleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        case .near:
          self.view.backgroundColor = UIColor.systemOrange
          self.distanceReading.text = "NEAR"
          self.ditanceCircleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        case .immediate:
          self.view.backgroundColor = UIColor.systemRed
          self.distanceReading.text = "RIGHT HERE"
          self.ditanceCircleView.transform = CGAffineTransform(scaleX: 1, y: 1)
        default:
          self.view.backgroundColor = UIColor.systemGray
          self.distanceReading.text = "UNKNOWN"
          self.beaconNameLabel.text = "Looking for beacon ..."
          self.ditanceCircleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    print("beacons: \(beacons)")
    guard !beacons.isEmpty else { return }
    if let beacon = beacons.first {
      print("beacon found: \(beacon.uuid)")
      if beacon.uuid != beaconDetected?.uuid {
        print("new beacon")
        beaconDetected = beacon
      }
      update(distance: beacon.proximity)
    } else {
      update(distance: CLProximity.unknown)
    }
  }
}

extension ViewController {
  private func configureDetectedBeacon(beacon: CLBeacon?) {
    guard let beacon = beacon else { return }
    let beaconUUIDString: String = beacon.uuid.uuidString
    beaconNameLabel.text = beaconUUIDString
    showAlertBeaconDetected(beaconName: beaconUUIDString)
  }

  private func showAlertBeaconDetected(beaconName: String) {
    let ac = UIAlertController(title: "Beacon Detected", message: beaconName, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(ac, animated: true)
  }
}
