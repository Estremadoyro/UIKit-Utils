//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Leonardo  on 7/02/22.
//

import SpriteKit

enum TargetType: String {
  case good = "target-good"
  case fast = "target-fast"
  case bad = "target-bad"
}

final class GameScene: SKScene {
  private var rows = [CGFloat]()
  private lazy var gameTimeLeft: Int = 30 {
    didSet {
      guard let timeLabel = self.timeLabel else { return }
      timeLabel.text = "Time: \(gameTimeLeft)s"
    }
  }

  private lazy var score: Int = 0 {
    didSet {
      guard let scoreLabel = self.scoreLabel else { return }
      scoreLabel.text = "Score: \(score)"
    }
  }

  private let targetTypes: [(targetType: TargetType, color: UIColor)] = [
    (TargetType.good, UIColor.systemGreen),
    (TargetType.fast, UIColor.systemBlue),
    (TargetType.bad, UIColor.systemPink),
  ]

  var gameTimer: CADisplayLink?
  var targetTimer: Timer?

  private var timeLabel: SKLabelNode!
  private var scoreLabel: SKLabelNode!

  override func didMove(to view: SKView) {
    createTimeLabel()
    createScoreLabel()
    createRows()

    targetTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)

    gameTimer = CADisplayLink(target: self, selector: #selector(handleTime))
    gameTimer?.preferredFramesPerSecond = 1
    gameTimer?.add(to: .current, forMode: .common)
  }

  private func createTimeLabel() {
    timeLabel = SKLabelNode()
    timeLabel.name = "time-label"
    timeLabel.text = "Time: \(gameTimeLeft)s"
    timeLabel.color = UIColor.white
    timeLabel.position = CGPoint(x: 100, y: 20)
    timeLabel.zPosition = 1
    addChild(timeLabel)
  }

  private func createScoreLabel() {
    scoreLabel = SKLabelNode()
    scoreLabel.name = "score-label"
    scoreLabel.text = "Score: \(score)"
    scoreLabel.color = UIColor.white
    scoreLabel.position = CGPoint(x: 100, y: frame.size.height - 50)
    scoreLabel.zPosition = 1
    addChild(scoreLabel)
  }

  @objc
  private func createTarget() {
    let targetNode = SKShapeNode(circleOfRadius: 100)
    let randomRow = Int.random(in: 0 ..< rows.count)
    let randomTarget = Int.random(in: 0 ..< targetTypes.count)
    let target = targetTypes[randomTarget]
    let speed = (target.targetType == TargetType.fast ? 1.5 * 0.5 : 1.5)

    targetNode.name = target.targetType.rawValue
    targetNode.position = CGPoint(x: 0, y: rows[randomRow])
    targetNode.strokeColor = UIColor.black
    targetNode.glowWidth = 10
    targetNode.fillColor = target.color

    targetNode.physicsBody = SKPhysicsBody(circleOfRadius: 100)
    targetNode.physicsBody?.affectedByGravity = false
    targetNode.physicsBody?.isDynamic = false
    targetNode.physicsBody?.collisionBitMask = 1
    targetNode.physicsBody?.contactTestBitMask = 1

    addChild(targetNode)
    let moveToRight = SKAction.moveBy(x: (frame.size.width) + targetNode.frame.width / 2, y: 0, duration: speed)
    targetNode.run(moveToRight)
  }

  @objc
  private func handleTime() {
    gameTimeLeft -= (gameTimeLeft > 0 ? 1 : 0)
    if gameTimeLeft == 0 {
      gameTimer?.invalidate()
      targetTimer?.invalidate()

      targetTimer = nil
      gameTimer = nil
    }
  }

  private func createRows() {
    let sceneHeight = frame.size.height
    let rowHeight = sceneHeight / 3
    let rowMiddleY = rowHeight / 2

    let row2positionY = (sceneHeight / 2) - rowMiddleY
    createRow(position: CGPoint(x: 0, y: sceneHeight))
    createRow(position: CGPoint(x: 0, y: row2positionY))
    createRow(position: CGPoint(x: 0, y: 0))
    rows.append(sceneHeight - rowMiddleY)
    rows.append(sceneHeight / 2)
    rows.append(rowMiddleY)
  }

  private func createRow(position: CGPoint) {
    let row = SKShapeNode()
    row.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 3)).cgPath
    row.position = position
    row.fillColor = UIColor.systemGray6.withAlphaComponent(0.2)
    row.strokeColor = UIColor.systemGray6
    row.lineWidth = 10
    addChild(row)
  }
}

extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    for node in children {
      if node.name == TargetType.good.rawValue || node.name == TargetType.fast.rawValue || node.name == TargetType.bad.rawValue {
        if node.position.x > frame.size.width {
          node.removeFromParent()
        }
      }
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    guard let tappedNode = nodes(at: location).first else { return }
    handleTap(tappedNode: tappedNode)
  }

  private func handleTap(tappedNode: SKNode) {
    guard let nodeName = tappedNode.name else { return }
    guard let targetType = TargetType(rawValue: nodeName) else { return }

    switch targetType {
      case .good:
        score += 1
      case .fast:
        score += 3
      case .bad:
        score -= (score > 0 ? 1 : 0)
    }
    deleteTarget(targetNode: tappedNode)
  }

  private func deleteTarget(targetNode: SKNode) {
    let fade = SKAction.fadeOut(withDuration: 1)
    targetNode.run(fade)
    targetNode.removeFromParent()
  }
}
