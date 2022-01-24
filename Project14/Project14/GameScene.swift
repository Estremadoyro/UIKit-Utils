//
//  GameScene.swift
//  Project14
//
//  Created by Leonardo  on 22/01/22.
//

import SpriteKit

final class GameScene: SKScene {
  var slots = [WhackSlot]()
  var gameScore: SKLabelNode!
  var popupTime = 0.85
  var rounds: Int = 0

  var score: Int = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }

  private lazy var finalScoreLabel: SKLabelNode = {
    let label = SKLabelNode()
    label.text = "Final Score: \(score)"
    label.fontName = "Chalkduster"
    label.zPosition = 1
    label.fontSize = 48
    label.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - (gameOver.position.y * 1.3))
    print(label.position)
    return label
  }()

  private lazy var gameOver: SKSpriteNode = {
    let node = SKSpriteNode(imageNamed: "gameOver")
    node.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    node.zPosition = 1
    return node
  }()

  override func didMove(to view: SKView) {
    let bg = SKSpriteNode(imageNamed: "whackBackground")
    bg.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    bg.blendMode = .replace // no alpha value in bg
    bg.zPosition = -1
    addChild(bg)

    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.text = "Score: 0"
    gameScore.position = CGPoint(x: 8, y: 8)
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)

    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.createEnemy()
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // continue = Next loop iteration
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)

    // more than 1 node can be tapped at the same time
    for node in tappedNodes {
      // get the WhackSlot node, which is inside a penguinNode < cropNode < WhackSlot
      guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
      // you may touch an already hidden penguin
      if !whackSlot.isVisible { continue }
      // you may hit twice a penguin that is still visible
      if whackSlot.isHit { continue }

      whackSlot.hit()
      
      if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
        fireParticles.position = whackSlot.position
        fireParticles.zPosition = 1
        addChild(fireParticles)
      }

      if node.name == "penguinFriend" {
        // killed peaceful penguin :(
        score -= (score <= 5 ? score : 5)
        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
      } else if node.name == "penguinEnemy" {
        // killed evil penguin
        // reduce penguin size
        whackSlot.penguinNode.xScale = 0.85
        whackSlot.penguinNode.yScale = 0.85

        score += 1
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
      }
    }
  }

  private func createSlot(at position: CGPoint) {
    let slot = WhackSlot()
    slot.configure(at: position)
    addChild(slot)
    slots.append(slot)
  }

  private func createEnemy() {
    rounds += 1
    if rounds >= 30 {
      for slot in slots {
        slot.hide()
      }
      addChild(gameOver)
      addChild(finalScoreLabel)
      gameScore.isHidden = true
//      run(SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: false))
      return
    }
    popupTime *= 0.991 // decrease time to create new enemy
    slots.shuffle()
    slots[0].show(hideTime: popupTime)

    if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
    if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }

    let minDelay = popupTime / 2
    let maxDelay = popupTime * 2
    let delay = Double.random(in: minDelay...maxDelay) // interval to create new enemy

    // Recursively call itself inbetween delays
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      self?.createEnemy()
    }
  }
}
