//
//  GameScene.swift
//  SpriteKitProject
//
//  Created by Leonardo  on 4/01/22.
//

import AudioToolbox
import SpriteKit

/// # All `nodes` should have `names`
/// # `SKPhysicsContactDelegate` ``Send colission notifications``
class GameScene: SKScene, SKPhysicsContactDelegate {
  private let balls: [String] = [
    "ballBlue",
    "ballCyan",
    "ballGreen",
    "ballGrey",
    "ballPurple",
    "ballRed",
    "ballYellow"
  ]

  private var ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
  private var ballsLeft = 5 {
    didSet {
      ballsLeftLabel.text = "Balls: \(ballsLeft)"
    }
  }

  private lazy var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
  private var score: Int = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }

  private lazy var editLabel = SKLabelNode(fontNamed: "Chalkduster")
  private var editingMode: Bool = false {
    didSet {
      if editingMode {
        editLabel.text = "Done"
      } else {
        editLabel.text = "Edit"
      }
    }
  }

  private var obstacles = 0

  private lazy var background = SKSpriteNode()
  private lazy var boxSprite = SKSpriteNode()
  private lazy var ballSprite = SKSpriteNode()
  private lazy var bouncerSprite = SKSpriteNode()
  private lazy var slotSprite = SKSpriteNode()
  private var obstacleSprite: SKSpriteNode!

  private func setBackground() {
    background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace // No transparency
    background.zPosition = -1 // All the way at the back
    addChild(background)
  }

  private func drawBoxSprite(position: CGPoint) {
    /// # Draw box
    boxSprite = SKSpriteNode(color: .systemRed, size: CGSize(width: frame.width / 3, height: 64))
    /// # Physics, make it the same dimensions as box
    boxSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width / 3, height: 64))
    boxSprite.position = position
    addChild(boxSprite)
  }

  private func drawBallSprite(position: CGPoint) {
    let randomBall = Int.random(in: 0 ..< balls.count)
    ballSprite = SKSpriteNode(imageNamed: balls[randomBall])
    ballSprite.physicsBody = SKPhysicsBody(circleOfRadius: ballSprite.size.width / 2)
    ballSprite.physicsBody?.restitution = 0.5 /// # Bouncines
    /// # `contactBitmask` is `what colissions should be notified?` ``Default to NONE``
    /// # `colissionBitMask` is `what other nodes should it collide with?` ``Default to EVERYTHING``
    /// # Then the `delegate` will notify the `allowed collissions`
    ballSprite.physicsBody?.contactTestBitMask = ballSprite.physicsBody?.collisionBitMask ?? 0
    ballSprite.position = position
    ballSprite.name = "ball"
    addChild(ballSprite)
  }

  private func drawBouncerSprite(position: CGPoint) {
    bouncerSprite = SKSpriteNode(imageNamed: "bouncer")
    /// # Without a physics body the other sprites whould `ignore it` and don't collision against it
    bouncerSprite.physicsBody = SKPhysicsBody(circleOfRadius: bouncerSprite.size.width / 2)
    bouncerSprite.physicsBody?.isDynamic = false
    bouncerSprite.position = position
    addChild(bouncerSprite)
  }

  private func drawSlotSprite(position: CGPoint, isGood: Bool) {
    var slowGlow: SKSpriteNode
    if isGood {
      slotSprite = SKSpriteNode(imageNamed: "slotBaseGood")
      slowGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotSprite.name = "good"
    } else {
      slotSprite = SKSpriteNode(imageNamed: "slotBaseBad")
      slowGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotSprite.name = "bad"
    }
    slotSprite.position = position
    slowGlow.position = position

    slotSprite.physicsBody = SKPhysicsBody(rectangleOf: slotSprite.size)
    slotSprite.physicsBody?.isDynamic = false

    addChild(slotSprite)
    addChild(slowGlow)

    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForever = SKAction.repeatForever(spin)
    slowGlow.run(spinForever)
  }

  private func drawInSameYCoordiante(spritesCount: Int, YAxis: CGFloat, drawSprite: (CGPoint) -> Void) {
    let chunk = frame.size.width / CGFloat(spritesCount - 1)
    for sprite in 0 ..< spritesCount {
      drawSprite(CGPoint(x: chunk * Double(sprite), y: YAxis + 30))
    }
  }

  private func drawSlotSprites() {
    let chunk = frame.size.width / CGFloat(4)
    let offset = bouncerSprite.size.width
    let positionY: CGFloat = 30.0
    drawSlotSprite(position: CGPoint(x: chunk * 0 + offset, y: positionY), isGood: true)
    drawSlotSprite(position: CGPoint(x: chunk + offset, y: positionY), isGood: false)
    drawSlotSprite(position: CGPoint(x: chunk * 2 + offset, y: positionY), isGood: true)
    drawSlotSprite(position: CGPoint(x: chunk * 3 + offset, y: positionY), isGood: false)
  }

  private func drawScoreLabel() {
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right // text alignment
    scoreLabel.position = CGPoint(x: frame.size.width - scoreLabel.frame.width / 4, y: frame.size.height - scoreLabel.frame.height * 2.5)
//    scoreLabel.position = CGPoint(x: 980, y: 700)
    print("x: \(frame.size.width)")
    print("y: \(frame.size.height)")
    addChild(scoreLabel)
  }

  private func drawEditLabel() {
    editLabel.text = "Edit"
    editLabel.horizontalAlignmentMode = .left
    editLabel.position = CGPoint(x: 10 + editLabel.frame.width / 4, y: frame.height - editLabel.frame.size.height * 2.5)
    addChild(editLabel)
  }

  private func drawBallsLeftLabel() {
    ballsLeftLabel.text = "Balls 5"
    ballsLeftLabel.horizontalAlignmentMode = .center
    ballsLeftLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 100)
    addChild(ballsLeftLabel)
  }

  private func drawObstacleSprite(position: CGPoint) {
    /// # Create random `size` for `block`
    let size = CGSize(width: Int.random(in: 0...Int(frame.size.width / 6)), height: 16)
    /// # Create the `random colors`
    obstacleSprite = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
    /// # Define its `initial rotation` (zRotation) ``Radians``
    obstacleSprite.zRotation = CGFloat.random(in: 0...2)
    /// # Set its position
    obstacleSprite.position = position // Tap location
    /// # Add physics so it can `collide`
    obstacleSprite.physicsBody = SKPhysicsBody(rectangleOf: obstacleSprite.size)
    /// # Won't move when collided with
    obstacleSprite.physicsBody?.isDynamic = false
    obstacleSprite.name = "obstacle"
    obstacles += 1
    addChild(obstacleSprite)
  }

  /// # Remove the `balls` that collide with the `slots (good|bad)`
  private func collisionBetween(ball: SKNode, object: SKNode) {
    /// # If the `ball` hits one of the `bottom platforms`
    if object.name == "good" {
      destroyNode(node: ball)
      score += 1
      ballsLeft += 1
    } else if object.name == "bad" {
      destroyNode(node: ball)
      score -= (score > 0 ? 1 : 0)
      if !children.contains(where: { $0.name?.contains("ball") ?? false }) {
        if ballsLeft < 1 {
          print("hit bad platform, no lives")
          playAgainAlert()
        }
      }
    } else if object.name == "obstacle" {
      destroyNode(node: object)
    }
  }

  /// # Remove node
  private func destroyNode(node: SKNode) {
    /// # Read animation
    if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
      fireParticles.position = node.position
      addChild(fireParticles)
    }
    node.removeFromParent()
  }

  /// # Called when 2 bodies `make contact` against each other
  /// # There are `3` scenarios:
  /// # When `A` collides with B
  /// # When `B` collides with A
  /// # When `A & B` collide at against each other, it creates `2 collisions` at the `same time`
  func didBegin(_ contact: SKPhysicsContact) {
    /// # To prevent having `removing` a `non-existant node`
    /// # ``ball hit slot and slot hit ball``
    /// # If either  `nodeA or nodeB` are `nil` (Already removed) due to the `2nd colission` at the `same time`
    /// # ``Can't`` prevent ``ghost collisions`` but you can deal with them
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    /// # `bodyA` first body to make contact
    /// # If `bodyA` is the ball then `bodyB` must be the `platform`
    if nodeA.name == "ball" {
      collisionBetween(ball: nodeA, object: nodeB)
    } else if nodeB.name == "ball" {
      collisionBetween(ball: nodeB, object: nodeA)
    }
  }

  private func playAgainAlert() {
    let ac = UIAlertController(title: "Game Over", message: "Score: \(score)", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Play again", style: .cancel) { [weak self] _ in
      self?.ballsLeft = 5
      self?.score = 5
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    })
    view?.window?.rootViewController?.present(ac, animated: true, completion: nil)
  }

  /// # Scene is presented by the view
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    /// # `physicsWorld` Physics simulation associated with the scene
    physicsWorld.contactDelegate = self
    setBackground()
    drawInSameYCoordiante(spritesCount: 5, YAxis: 0) { [weak self] position in
      self?.drawBouncerSprite(position: position)
    }
    drawSlotSprites()
    drawScoreLabel()
    drawEditLabel()
    drawBallsLeftLabel()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /// # Register first touch
    guard let touch = touches.first else { return }
    /// # Find where the touch was
    var location = touch.location(in: self)
    /// # Get all nodes at `tap location`
    let objects = nodes(at: location)
    /// # Check if the `editLabel` was tapped
    if objects.contains(editLabel) {
      editingMode.toggle()
    } else {
      if editingMode {
        drawObstacleSprite(position: location)
      } else {
        if ballsLeft > 0 {
          location = CGPoint(x: location.x, y: frame.size.height * 0.9)
          drawBallSprite(position: location)
          ballsLeft -= (ballsLeft > 0 ? 1 : 0)
        }
      }
    }
  }
}
