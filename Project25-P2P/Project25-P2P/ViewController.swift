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

final class ViewController: UICollectionViewController {
  private var photoPicker: PhotoPicker?

  // Identifies each user uniquely in a session
  private let peerID = MCPeerID(displayName: UIDevice.current.name)

  // Manages all the connected devices (peers), and allows sending and recieving messages
  private var mcSession: MCSession?

  // Used to advertise the session, propagating our user
  private var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?

  // Look for a service in the network
  private var mcServiceBrowser: MCNearbyServiceBrowser?

  private var images = [UIImage]()

  var connectedPeersAmount: Int = 0

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
    let connectionItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    let connectedUsersItem = UIBarButtonItem(image: UIImage(systemName: "person.2.wave.2.fill"), style: .plain, target: self, action: #selector(showConnectedUsers))
    navigationItem.leftBarButtonItems = [connectionItem, connectedUsersItem]
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
          let customMessage: String = "Let's get excited"
          let customMessageData = Data(customMessage.utf8)
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
          try mcSession.send(customMessageData, toPeers: mcSession.connectedPeers, with: .reliable)
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
    let hostSessionAction = UIAlertAction(title: "Host a session", style: .default, handler: configureServiceAdvertiser)
    let joinSessionAction = UIAlertAction(title: "Join session", style: .default, handler: configureServiceBrowser)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(hostSessionAction)
    ac.addAction(joinSessionAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }
}

extension ViewController {
  private func configureP2P() {
    configureMCSession()
  }

  private func configureMCSession() {
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
    mcSession?.delegate = self
  }

  private func configureServiceAdvertiser(action: UIAlertAction) {
    let serviceType: String = P2PConfig.serviceType.rawValue
    mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
    mcNearbyServiceAdvertiser?.delegate = self
    mcNearbyServiceAdvertiser?.startAdvertisingPeer()
  }

  private func configureServiceBrowser(action: UIAlertAction) {
    guard let mcSession = mcSession else { fatalError("Failed accessing session") }
    let serviceType: String = P2PConfig.serviceType.rawValue
    let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }

  private func alertUserDisconnected(peer: MCPeerID) {
    let ac = UIAlertController(title: "Disconnected", message: "\(peer.displayName) disconnected from the network", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(ac, animated: true)
  }

  @objc
  private func showConnectedUsers() {
    var aux: String = ""
    mcSession!.connectedPeers.forEach { peer in
      aux += "- \(peer.displayName)\n"
    }
    let connectedUsersMessage: String = """
    Users:
    \(aux.isEmpty ? "No users" : aux)
    """
    let ac = UIAlertController(title: "Connected Users", message: connectedUsersMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(ac, animated: true)
  }
}

extension ViewController: MCSessionDelegate {
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
      case .connected:
        connectedPeersAmount += 1
        print("Connected: \(peerID.displayName)")
      case .connecting:
        print("Connecting: \(peerID.displayName)")
      // Device disconnected
      case .notConnected:
        if connectedPeersAmount >= 1 {
          DispatchQueue.main.async { [unowned self] in
            self.alertUserDisconnected(peer: peerID)
            self.connectedPeersAmount -= 1
          }
        }

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

      let customMessage = String(decoding: data, as: UTF8.self)
      self?.navigationItem.title = customMessage
    }
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

extension ViewController: MCNearbyServiceAdvertiserDelegate {
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    let ac = UIAlertController(title: "Connect Request", message: "\(peerID.displayName) wants to connect", preferredStyle: .alert)
    let acceptedAction = UIAlertAction(title: "Accept", style: .default) { [unowned self] _ in
      guard let mcSession = self.mcSession else { return }
      invitationHandler(true, mcSession)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
      guard let mcSession = self.mcSession else { return }
      invitationHandler(false, mcSession)
    }

    ac.addAction(acceptedAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }
}
