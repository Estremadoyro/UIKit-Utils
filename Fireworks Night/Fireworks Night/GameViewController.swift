//
//  GameViewController.swift
//  Fireworks Night
//
//  Created by Leonardo  on 16/02/22.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill

        // Present the scene
        view.presentScene(scene)
      }

      view.ignoresSiblingOrder = true

      view.showsFPS = true
      view.showsNodeCount = true
    }
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    // get the SKView
    guard let skView = view as? SKView else { return }
    // get the scene
    guard let gameScene = skView.scene as? GameScene else { return }
    gameScene.explodeFireworks()
  }
}
