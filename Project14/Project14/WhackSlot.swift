//
//  WhackSlot.swift
//  Project14
//
//  Created by Leonardo  on 22/01/22.
//

import SpriteKit

class WhackSlot: SKNode {
  var penguinNode: SKSpriteNode!
  var isVisible: Bool = false
  var isHit: Bool = false

  func configure(at position: CGPoint) {
    name = "Whackslot"
    self.position = position
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    sprite.name = "whack-hole"
    addChild(sprite)

    penguinNode = SKSpriteNode(imageNamed: "penguinGood")
    penguinNode.position = CGPoint(x: 0, y: -penguinNode.size.height - 4)
    penguinNode.name = "penguin"

    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 20)
    cropNode.zPosition = 1
    cropNode.name = "crop-node"
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
    cropNode.addChild(penguinNode)

    addChild(cropNode)
  }

  func show(hideTime: Double) {
    // reset penguin size
    penguinNode.xScale = 1
    penguinNode.yScale = 1
    if isVisible { return } // check if it's already visible
    penguinNode.run(SKAction.moveBy(x: 0, y: penguinNode.size.height, duration: 0.5))
    isVisible = true
    isHit = false

    if Int.random(in: 0 ... 2) == 0 {
      penguinNode.texture = SKTexture(imageNamed: "penguinGood")
      penguinNode.name = "penguinFriend"
    } else {
      penguinNode.texture = SKTexture(imageNamed: "penguinEvil")
      penguinNode.name = "penguinEnemy"
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) { [weak self] in
      self?.hide()
    }
  }

  func hide() {
    if !isVisible { return }
    penguinNode.run(SKAction.moveBy(x: 0, y: -penguinNode.size.height, duration: 0.05))
    isVisible = false
  }

  func hit() {
    isHit = true
    let delay = SKAction.wait(forDuration: 0.25)
    let hide = SKAction.moveBy(x: 0, y: -penguinNode.size.height, duration: 0.5)
    let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
    // make sure it's set hidden only after the animation has ended
    // executes one after the other in a sync manner
    penguinNode.run(SKAction.sequence([delay, hide, notVisible]))
  }
}
