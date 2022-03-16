//
//  ViewController.swift
//  Project25-P2P
//
//  Created by Leonardo  on 14/03/22.
//

import MultipeerConnectivity
import UIKit

enum P2PConfig: String {
  case serviceType = "lec-project25"
}

final class ViewController: UICollectionViewController, MCNearbyServiceAdvertiserDelegate {
  private var photoPicker: PhotoPicker?

  // Identifies each user uniquely in a session
  private var peerID: MCPeerID?

  // Manager class that handles all multipeer connectivity
  private var mcSession: MCSession?

  // Used when creating a session, propagating our user
//  private var mcAdvertiserAssistant: MCAdvertiserAssistant?
  private var mcAdvertiserAssistant: MCNearbyServiceAdvertiser?

  private var images = [UIImage]()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavBar()
    configureP2P()
  }
}

extension ViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }

    return cell
  }
}

private extension ViewController {
  func configureNavBar() {
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
  }
}

private extension ViewController {
  @objc
  func importPicture() {
    photoPicker = PhotoPicker()
    photoPicker?.photoPickerDelegate = self

    guard let photoPickerVC = photoPicker?.photoPickerVC else { return }
    present(photoPickerVC, animated: true)
  }
}

extension ViewController: PhotoPickerDelegate {
  func didSelectPhoto(photo: UIImage) {
    photoPicker = nil // clean up
    images.insert(photo, at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    collectionView.insertItems(at: [indexPath])

    guard let mcSession = mcSession else { return }
    if mcSession.connectedPeers.count > 0 {
      // Converting UIImage to pngData (Data)
      if let imageData = photo.pngData() {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
          // Swift created the new constant "error" for us to use when "catch" gets ran
        } catch {
          let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "Ok", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
}

extension ViewController {
  @objc
  private func showConnectionPrompt() {
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
    let hostSessionAction = UIAlertAction(title: "Host a session", style: .default, handler: configureHosting)
    let joinSessionAction = UIAlertAction(title: "Join session", style: .default, handler: joinSession)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(hostSessionAction)
    ac.addAction(joinSessionAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }
}

extension ViewController {
  private func configureP2P() {
    configurePeerID()
    configureMCSession()
  }

  private func configurePeerID() {
    let deviceName: String = UIDevice.current.name
    peerID = MCPeerID(displayName: deviceName)
  }

  private func configureMCSession() {
    guard let peerID = peerID else { fatalError("Failed creating PeerID") }
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
  }

  private func configureHosting(action: UIAlertAction) {
    guard let mcSession = mcSession else { fatalError("Failed accessing session") }
    let serviceType: String = P2PConfig.serviceType.rawValue
//    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID!, discoveryInfo: nil, serviceType: serviceType)
    mcAdvertiserAssistant?.delegate = self

    // Begins advertising and starts the assistant
//    mcAdvertiserAssistant?.start()
    mcAdvertiserAssistant?.startAdvertisingPeer()
  }

  private func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { fatalError("Failed accessing session") }
    let serviceType: String = P2PConfig.serviceType.rawValue

    // Used when looking for sessions, in charge of showing users that are nearby
    let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
}

extension ViewController: MCSessionDelegate {
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
      case .connected:
        print("Connected: \(peerID.displayName)")
      case .connecting:
        print("Connecting: \(peerID.displayName)")
      case .notConnected:
        print("Not connected: \(peerID.displayName)")
      @unknown default:
        print("Unknown state recieved")
    }
  }

  // When recieving data
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self?.collectionView.insertItems(at: [indexPath])
      }
    }
  }
}

extension ViewController: MCAdvertiserAssistantDelegate {
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    print("resolved invitation from: \(peerID.displayName)")
  }
}

extension ViewController: MCBrowserViewControllerDelegate {
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }

  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
}
