//
//  GameScene.swift
//  Project17
//
//  Created by Leonardo  on 5/02/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var starfield: SKEmitterNode!
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var restartGameLabel: SKLabelNode?
  
  let possibleEnemies = ["ball", "hammer", "tv"]
  
  var gameTimer: Timer?
  var isGameOver = false
  var isPlayerTouched: Bool = false
  var enemiesCount = 0
  var currentTimeInterval: CGFloat = 1.0

  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }

  override func didMove(to view: SKView) {
    backgroundColor = UIColor.black
    starfield = SKEmitterNode(fileNamed: "starfield")!
    starfield.position = CGPoint(x: 1024, y: 384)
    // start animation 10 seconds ahead
    starfield.advanceSimulationTime(10)
    addChild(starfield)
    starfield.zPosition = -1 // behind everything else
    
    player = SKSpriteNode(imageNamed: "player")
    player.name = "player"
    player.position = CGPoint(x: 100, y: 384)
    // physics applied to the drawing texture of the player
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.contactTestBitMask = 1 // collide with other 1's
    addChild(player)
    
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    score = 0
    
    physicsWorld.gravity = .zero // no gravity
    // per-pixel collision
    physicsWorld.contactDelegate = self
    
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
  }
  
  @objc
  private func createEnemy() {
    guard let enemy = possibleEnemies.randomElement() else { return }
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.name = "enemy"
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50 ... 736))
    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.categoryBitMask = 1 // collide with player
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // from right to left, same y coordinate
    sprite.physicsBody?.angularVelocity = 5 // spin while moving
    sprite.physicsBody?.linearDamping = 0 // hwo fast things slow down, never slows with 0
    sprite.physicsBody?.angularDamping = 0 // when to stop spinning, never stops with 0
    enemiesCount += 1
    if enemiesCount % 5 == 0 {
      gameTimer?.invalidate()
      currentTimeInterval -= currentTimeInterval * 0.1
      gameTimer = Timer.scheduledTimer(timeInterval: currentTimeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
  }

  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    for node in children {
      if node.name == "enemy" {
        if node.position.x < 0 {
          node.removeFromParent()
        }
      }
    }
    if !isGameOver {
      score += 1
    }
  }
  
  private func restartGame() {
    if let restartGameLabel = restartGameLabel {
      restartGameLabel.removeFromParent()
      self.restartGameLabel = nil
      addChild(player)
    }
    player.position = CGPoint(x: 100, y: 384)
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    score = 0
    enemiesCount = 0
    currentTimeInterval = 1
    isPlayerTouched = false
    isGameOver = false
    // remove all nodes when game restart
    for node in children {
      if node.name == "enemy" {
        node.removeFromParent()
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    var location = touch.location(in: self)
    
    if location.y < 100 {
      location.y = 100
    } else if location.y > 668 {
      location.y = 668
    }
    // move player along touch moving
    if isPlayerTouched {
      player.position = location
    }
  }
  
  // when 2 objs contact againts each other
  func didBegin(_ contact: SKPhysicsContact) {
    let explosion = SKEmitterNode(fileNamed: "explosion")!
    explosion.position = player.position
    addChild(explosion)
    
    player.removeFromParent()
    isGameOver = true
    gameTimer?.invalidate()
    gameTimer = nil
    
    if restartGameLabel == nil {
      restartGameLabel = SKLabelNode(fontNamed: "Chalkduster")
      if let restartGameLabel = restartGameLabel {
        restartGameLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        restartGameLabel.name = "restart"
        restartGameLabel.text = "Play Again"
        restartGameLabel.zPosition = 1
        addChild(restartGameLabel)
        print("1 \(restartGameLabel.parent)")
      }
    }
  }

  // finger raised
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    player.position = CGPoint(x: 100, y: 384)
    isPlayerTouched = false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    guard let tappedNode = nodes(at: location).first else { return }
    if tappedNode.name == "player" {
      isPlayerTouched = true
    } else if tappedNode.name == "restart" {
      print("tapped restart")
      restartGame()
      return
    }
  }
}
