//
//  GameScene.swift
//  Fireworks Night
//
//  Created by Leonardo  on 16/02/22.
//

import SpriteKit

final class GameScene: SKScene {
  var gameTimer: Timer?
  var fireworks = [SKNode]()
  var totalLaunches: Int = 0
  
  let leftEdge = -22
  let bottomEdge = -22
  let rightEdge = 1024 + 22
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  private lazy var scoreLabel: SKLabelNode = {
    let label = SKLabelNode()
    label.text = "Score: \(score)"
    label.horizontalAlignmentMode = .left
    label.fontSize = 42
    label.fontColor = UIColor.white
    label.position = CGPoint(x: frame.minX + label.frame.size.width / 2, y: 30)
    label.zPosition = 1
    return label
  }()
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(scoreLabel)
    addChild(background)
    
    gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
  }
  
  private func createFirework(xMovement: CGFloat, x: Int, y: Int) {
    let node = SKNode()
    node.position = CGPoint(x: x, y: y)
    
    let firework = SKSpriteNode(imageNamed: "rocket")
    firework.colorBlendFactor = 1 // full color by any color set
    firework.name = "firework"
    node.addChild(firework)
    
    switch Int.random(in: 0 ... 2) {
      case 0:
        firework.color = .cyan
      case 1:
        firework.color = .green
      default:
        firework.color = .red
    }
    
    let path = UIBezierPath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: xMovement, y: 1000))
    
    // asOffset: start where sprite starts (relative position), if not then it will have an abosute position
    // orientToPath: always follow the path
    let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
    node.run(move)
    
    let emitter = SKEmitterNode(fileNamed: "fuse")!
    emitter.position = CGPoint(x: 0, y: -22)
    node.addChild(emitter)
    
    fireworks.append(node)
    addChild(node)
  }
  
  @objc
  private func launchFireworks() {
    if totalLaunches == 15 {
      gameTimer?.invalidate()
      gameTimer = nil
      return
    }
    let movementAmount: CGFloat = 1800
    switch Int.random(in: 0 ... 3) {
      case 0:
        // fire 5 fireworks, straight up
        createFirework(xMovement: 0, x: 512, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
        createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
      case 1:
        // fire 5 fireworks, in a fan
        createFirework(xMovement: 0, x: 512, y: bottomEdge)
        createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
        createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
        createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
        createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
      case 2:
        // fire 5 fireworks, left to right
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
        createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
      case 3:
        // fire 5 fireworks, right to left
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
        createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
      default:
        break
    }
    totalLaunches += 5
  }

  private func checkTouches(_ touches: Set<UITouch>) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let nodesAtPoint = nodes(at: location)
    
    for case let node as SKSpriteNode in nodesAtPoint {
      guard node.name == "firework" else { continue }
      for parent in fireworks {
        // check if it is the rocket sprite used
        guard let firework = parent.children.first as? SKSpriteNode else { continue }
        // check if the firework is selected already and if its color is different from the currently new selected one
        if firework.name == "selected", firework.color != node.color {
          // unselect it
          firework.name = "firework"
          firework.colorBlendFactor = 1
        }
      }
      // update the tapped node
      node.name = "selected"
      node.colorBlendFactor = 0
      print("fireworks array")
      let fireworksNames = fireworks.map { $0.children.first?.name ?? "no-name" }
      print(fireworksNames)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    checkTouches(touches)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    checkTouches(touches)
  }
  
  override func update(_ currentTime: TimeInterval) {
    // reversed so you don't check an index that no longer exists, as result of removing it and hence the array is shorter, so the index may be out of bounds.
    // 1 2 3 4 (Say remove 3) (i: 2)
    // 1 2 4 (There are now 3 elements, but the loop i is now pointing to 3) (i: 3, out of bounds)
    for (index, firework) in fireworks.enumerated().reversed() {
      if firework.position.y > 900 {
        fireworks.remove(at: index)
        firework.removeFromParent()
      }
    }
  }

  private func explode(firework: SKNode) {
    if let emitter = SKEmitterNode(fileNamed: "explode") {
      emitter.position = firework.position
      addChild(emitter)
      let waitAction = SKAction.wait(forDuration: 0.5)
      let removeAction = SKAction.removeFromParent()
      let sequence = SKAction.sequence([waitAction, removeAction])
      emitter.run(sequence)
    }
    firework.removeFromParent()
  }
  
  public func explodeFireworks() {
    var numExploded = 0
    for (index, fireWorkContainer) in fireworks.enumerated().reversed() {
      guard let firework = fireWorkContainer.children.first as? SKSpriteNode else { continue }
      if firework.name == "selected" {
        // destroy this firework
        explode(firework: fireWorkContainer)
        fireworks.remove(at: index)
        numExploded += 1
      }
    }
    switch numExploded {
      case 0:
        break
      case 1:
        score += 200
      case 2:
        score += 500
      case 3:
        score += 1500
      case 4:
        score += 2500
      default:
        score += 400
    }
  }
}
