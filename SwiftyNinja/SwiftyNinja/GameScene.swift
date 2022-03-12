//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Leonardo  on 10/03/22.
//

import AVFoundation
import SpriteKit

enum ForceBomb {
  case never
  case always
  case random
}

enum SequenceType: CaseIterable {
  case oneNoBomb // 1st when start game
  case one // 1st when start game
  case twoWithOneBomb
  case two
  case three
  case four
  case chain
  case fastChain
  case fastExtraPoints
}

class GameScene: SKScene {
  var gameScore: SKLabelNode!
  var gameOverNode: SKLabelNode!
  var playAgainNode: SKShapeNode!
  var score = 0 {
    didSet {
      gameScore.text = "Score: \(score)"
    }
  }

  var livesImages = [SKSpriteNode]()
  var lives: Int = 3

  var activeSliceBG: SKShapeNode! // background slice
  var activeSliceFG: SKShapeNode! // foreground slice

  var activeSlicePoints = [CGPoint]()
  var isSliceSoundActive: Bool = false

  var activeEnemies = [SKSpriteNode]()
  var bombSoundEffect: AVAudioPlayer?

  var popupTime: CGFloat = 0.9 // time between enenmies creation
  var sequence = [SequenceType]() // store enemies to be created
  var sequencePosition: Int = 0 // current sequence type position
  var chainDelay: CGFloat = 3.0 // time to wait when type is chain
  var nextSequenceQueued: Bool = true // when all enemies from a sequence have been destroyed

  var isGameEnded: Bool = false

  let enemyRandomPosition: (XMin: Int, XMax: Int, y: Int) = (XMin: 64, XMax: 960, y: -128)
  let enemyRandomXVelocityHigh: (XMin: Int, XMax: Int) = (XMin: 8, XMax: 15)
  let enemyRandomXVelocityLow: (XMin: Int, XMax: Int) = (XMin: 3, XMax: 5)
  let enemyRandomAngularVelocity: (AMin: CGFloat, AMax: CGFloat) = (AMin: 3.0, AMax: 3.0)
  let enemyRandomYVelocity: (YMin: Int, YMax: Int) = (YMin: 24, YMax: 32)
  let velocityBoost: Int = 40
  let enemyRadius: CGFloat = 64.0

  let bombLeftThreshold: CGFloat = 256.0
  let bombVeryLeftThreshold: CGFloat = 512.0
  let bombRightThreshold: CGFloat = 768.0

  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "sliceBackground")
    background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)

    physicsWorld.gravity = CGVector(dx: 0, dy: -6)
    physicsWorld.speed = 0.85

    createScore()
    createLives()
    createSlices()

    sequence = [.fastExtraPoints, .oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

    for _ in 0 ... 1000 {
      if let nextSequence = SequenceType.allCases.randomElement() {
        sequence.append(nextSequence)
      }
    }

    // start creating enemies after 1 second have passed
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.tossEnemies()
    }
  }
}

extension GameScene {
  private func createScore() {
    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    score = 0
    addChild(gameScore)
    gameScore.position = CGPoint(x: 0, y: gameScore.frame.size.height)
  }

  private func createLives() {
    for i in 0 ..< 3 {
      let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
      spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: frame.size.height - spriteNode.frame.size.height)
      addChild(spriteNode)
      livesImages.append(spriteNode)
    }
  }

  private func createSlices() {
    activeSliceBG = SKShapeNode()
    activeSliceBG.zPosition = 2
    activeSliceBG.strokeColor = UIColor.systemYellow
    activeSliceBG.lineWidth = 9
    addChild(activeSliceBG)

    activeSliceFG = SKShapeNode()
    activeSliceFG.zPosition = 3
    activeSliceFG.strokeColor = UIColor.white
    activeSliceFG.lineWidth = 7
    addChild(activeSliceFG)
  }

  private func createGameOverNode() {
    gameOverNode = SKLabelNode()
    gameOverNode.name = "gameOverNode"
    gameOverNode.text = "Game Over"
    gameOverNode.fontSize = 68
    gameOverNode.zPosition = 10
    gameOverNode.horizontalAlignmentMode = .center
    addChild(gameOverNode)
    gameOverNode.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
  }

  private func createPlayAgainNode() {
    playAgainNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 300, height: 100), cornerRadius: 25)
    playAgainNode.name = "playAgainNode"
    playAgainNode.zPosition = 10

    let XPosition: CGFloat = (frame.size.width / 2) - (playAgainNode.frame.size.width / 2)
    let YPosition: CGFloat = frame.size.height * 0.3
    playAgainNode.position = CGPoint(x: XPosition, y: YPosition)

    playAgainNode.fillColor = UIColor.systemBlue
    playAgainNode.strokeColor = UIColor.systemBlue.withAlphaComponent(0.5)
    playAgainNode.glowWidth = 10

    let playAgainLabel = SKLabelNode()
    playAgainLabel.name = "playAgainLabel"
    playAgainLabel.text = "Play Again"
    playAgainLabel.zPosition = 11
    playAgainLabel.horizontalAlignmentMode = .center

    addChild(playAgainNode)
    playAgainNode.addChild(playAgainLabel)
    playAgainLabel.position = CGPoint(x: playAgainNode.frame.size.width / 2 - (playAgainLabel.frame.size.width / 10), y: playAgainNode.frame.size.height / 2 - (playAgainLabel.frame.size.height / 2))
  }
}

extension GameScene {
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard isGameEnded == false else { return }

    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    activeSlicePoints.append(location)
    redrawActiveSlice()
    // one sound at the time
    if !isSliceSoundActive {
      playSliceSound()
    }

    let nodesAtPoint = nodes(at: location)
    // Only loop if the node can be downcasted to SKSpriteNode
    for case let node as SKSpriteNode in nodesAtPoint {
      if node.name == "enemy" {
        // destroy penguin
        if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
          emitter.position = node.position
          addChild(emitter)
        }

        // remove its name, so it can't get sliced twice
        node.name = ""
        node.physicsBody?.isDynamic = false
        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)

        // run actions simultaneously
        let group = SKAction.group([scaleOut, fadeOut])

        // then, in a sequence, animate dissppearing and removing in said order
        let seq = SKAction.sequence([group, .removeFromParent()])
        node.run(seq)

        print("Sequence position: \(sequencePosition)")
        print("Sequence length: \(sequence.count)")
        let launchedSequence: SequenceType = sequence[sequencePosition - 1]
        print("LAUNCHED SEQUENCE: \(launchedSequence.self)")
        let pointsEarned: Int = (launchedSequence == .fastExtraPoints ? 2 : 1)
        score += pointsEarned

        // remove enemy from active list
        if let index = activeEnemies.firstIndex(of: node) {
          activeEnemies.remove(at: index)
        }

        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))

      } else if node.name == "bomb" {
        // destroy bomb
        guard let bombContainer = node.parent as? SKSpriteNode else { continue }

        if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
          emitter.position = bombContainer.position
          addChild(emitter)
        }
        // remove its name, so it can't get sliced twice
        node.name = ""
        bombContainer.physicsBody?.isDynamic = false

        let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)

        // run actions simultaneously
        let group = SKAction.group([scaleOut, fadeOut])

        // then, in a sequence, animate dissppearing and removing in said order
        let seq = SKAction.sequence([group, .removeFromParent()])
        bombContainer.run(seq)

        if let index = activeEnemies.firstIndex(of: bombContainer) {
          activeEnemies.remove(at: index)
        }

        run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
        node.name = ""
        endGame(triggeredByBomb: true)
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNode = atPoint(location)
    if tappedNode.name == "playAgainNode" || tappedNode.name == "playAgainLabel" {
      resetGame()
      print("PLAY AGAIN!")
      return
    }
    activeSlicePoints.removeAll(keepingCapacity: true)

    activeSlicePoints.append(location)
    redrawActiveSlice()

    // Remove actions when touching again
    activeSliceBG.removeAllActions()
    activeSliceBG.alpha = 1
    activeSliceFG.removeAllActions()
    activeSliceFG.alpha = 1
  }

  // called every frame BEFORE it's drawn
  override func update(_ currentTime: TimeInterval) {
    if activeEnemies.count > 0 {
      // reversed so it can delete with an index from right to left, indexes from List won't be updated
      for (index, node) in activeEnemies.enumerated().reversed() {
        if node.position.y < -140 || node.position.y > frame.size.height + 5 || node.position.x < -5 || node.position.x > frame.size.width + 5 {
          node.removeAllActions()
          // if doesn't slice penguin, then loose a life
          if node.name == "enemy" {
            node.name = ""
            node.removeFromParent() // remove either way
            activeEnemies.remove(at: index) // remove from activeEnemies either way. There can only be 2 types of enemies (enemy & bombContainer)
            subtractLife()
          } else if node.name == "bombContainer" {
            node.name = ""
            node.removeFromParent() // remove either way
            activeEnemies.remove(at: index) // remove from activeEnemies either way. There can only be 2 types of enemies (enemy & bombContainer)
          }
        }
      }
    } else {
      // this should only run after a toss has happened before, in the 0x toss there is no -1x toss, so this prevent from running it twice the first time (1st run @ didMove())
      if !nextSequenceQueued {
        DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
          self?.tossEnemies()
        }
        // schedule next enemy sequence
        nextSequenceQueued = true
      }
    }
    var bombCount: Int = 0

    // find if there is a bomb on screen
    for node in activeEnemies {
      if node.name == "bombContainer" {
        bombCount += 1
        break
      }
    }

    // if no bomb on screen, stop the fuse sound
    if bombCount == 0 {
      bombSoundEffect?.stop()
      bombSoundEffect = nil
    }
  }
}

extension GameScene {
  // penguin fell off the screen without beign sliced
  private func subtractLife() {
    lives -= (lives > 0 ? 1 : 0)
    run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
    var life: SKSpriteNode

    if lives == 2 {
      life = livesImages[0]
    } else if lives == 1 {
      life = livesImages[1]
    } else {
      life = livesImages[2]
      endGame(triggeredByBomb: false)
    }

    life.texture = SKTexture(imageNamed: "sliceLifeGone")
    life.xScale = 1.3
    life.yScale = 1.3
    life.run(SKAction.scale(to: 1, duration: 0.2))
  }

  private func endGame(triggeredByBomb: Bool) {
    // prevent for running twice, if tho it shouldn't
    guard isGameEnded == false else { return }
    isGameEnded = true
    physicsWorld.speed = 0
//    isUserInteractionEnabled = false

    bombSoundEffect?.stop()
    bombSoundEffect = nil

    print("GAME END")
    sequence = []

    // change all lifes to gone
    if triggeredByBomb {
      livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
    }

    createGameOverNode()
    createPlayAgainNode()
  }

  private func resetGame() {
    gameOverNode.removeFromParent()
    playAgainNode.removeFromParent()
    for activeEnemy in activeEnemies {
      activeEnemy.removeFromParent()
      activeEnemy.removeAllActions()
    }
    activeEnemies = []
    score = 0
    lives = 3
    popupTime = 1 // time ramps up
    chainDelay = 1
    physicsWorld.speed = 1
    isGameEnded = false
    sequence = [.fastExtraPoints, .oneNoBomb, .fastExtraPoints, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
    sequencePosition = 0

    for lifeImage in livesImages {
      lifeImage.texture = SKTexture(imageNamed: "sliceLife")
    }

    nextSequenceQueued = true
    for _ in 0 ... 1000 {
      if let nextSequence = SequenceType.allCases.randomElement() {
        sequence.append(nextSequence)
      }
    }

    // start creating enemies after 1 second have passed
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.tossEnemies()
    }
  }

  private func playSliceSound() {
    isSliceSoundActive = true
    let randomNumber = Int.random(in: 1 ... 3)
    let soundName: String = "swoosh\(randomNumber).caf"
    let sliceSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

    // wait for the sound end to play another
    run(sliceSound) { [weak self] in
      self?.isSliceSoundActive = false
    }
  }

  private func redrawActiveSlice() {
    // not enouch points to make a line on the screen
    if activeSlicePoints.count < 2 {
      activeSliceBG.path = nil
      activeSliceFG.path = nil
      return
    }

    // stop line from beign too long
    if activeSlicePoints.count > 12 {
      activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
    }

    let path = UIBezierPath()
    // go to 1st slice point in the screen
    path.move(to: activeSlicePoints[0])

    // add line for every slice position saved
    for i in 1 ..< activeSlicePoints.count {
      path.addLine(to: activeSlicePoints[i])
    }

    activeSliceBG.path = path.cgPath
    activeSliceFG.path = path.cgPath
  }
}

extension GameScene {
  private func createEnemy(forceBomb: ForceBomb = .random, specialSettingsEnemy: Bool = false) {
    let enemy: SKSpriteNode
    var enemyType = Int.random(in: 0 ... 6)
    // 0 -> Bomb
    if forceBomb == .never {
      enemyType = 1
    } else if forceBomb == .always {
      enemyType = 0
    }

    if enemyType == 0 {
      // bomb code here
      // 1. Bomb image
      // 2. Fuse emitter
      // 3. Container with both of them
      enemy = SKSpriteNode()
      enemy.zPosition = 1 // ahead penguins and BG
      enemy.name = "bombContainer"

      let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
      bombImage.name = "bomb"
      enemy.addChild(bombImage)

      // stop bomb sound if exists, before creating a new bomb
      if bombSoundEffect != nil {
        bombSoundEffect?.stop()
        bombSoundEffect = nil
      }

      // Using AVFoundation to stop a sound effect
      if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
        if let sound = try? AVAudioPlayer(contentsOf: path) {
          bombSoundEffect = sound
          sound.play()
        }
      }

      let emitter = SKEmitterNode(fileNamed: "sliceFuse")!
      emitter.position = CGPoint(x: 76, y: 64)

      enemy.addChild(emitter)

    } else {
      // penguin code
      enemy = SKSpriteNode(imageNamed: "penguin")
      run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
      enemy.name = "enemy"
      if specialSettingsEnemy {
        enemy.color = UIColor.systemYellow
        enemy.colorBlendFactor = 0.5
      }
    }
    // position code
    let randomPosition = CGPoint(x: Int.random(in: enemyRandomPosition.XMin ... enemyRandomPosition.XMax), y: enemyRandomPosition.y)
    enemy.position = randomPosition

    // rotation velocity
    let randomAngularVelocity = CGFloat.random(in: enemyRandomAngularVelocity.AMin ... enemyRandomAngularVelocity.AMax)
    // movement speed
    var randomXVelocity: Int
    // way to the left
    if randomPosition.x < bombVeryLeftThreshold {
      randomXVelocity = Int.random(in: enemyRandomXVelocityHigh.XMin ... enemyRandomXVelocityHigh.XMax)
      // to the left
    } else if randomPosition.x < bombLeftThreshold {
      randomXVelocity = Int.random(in: enemyRandomXVelocityLow.XMin ... enemyRandomXVelocityLow.XMax)
      // to the right
    } else if randomPosition.x < bombRightThreshold {
      randomXVelocity = -Int.random(in: enemyRandomXVelocityLow.XMin ... enemyRandomXVelocityLow.XMax)
      // way to the right
    } else {
      randomXVelocity = -Int.random(in: enemyRandomXVelocityHigh.XMin ... enemyRandomXVelocityHigh.XMax)
    }

    var randomYVelocity = Int.random(in: enemyRandomYVelocity.YMin ... enemyRandomYVelocity.YMax)

    if specialSettingsEnemy {
      randomXVelocity += 10
      randomYVelocity += 10
    }

    // physics body, half sprite size (128 -> 64)
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemyRadius)
    enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * velocityBoost, dy: randomYVelocity * velocityBoost)
    enemy.physicsBody?.angularVelocity = randomAngularVelocity
    enemy.physicsBody?.collisionBitMask = 0 // no other object can collide with it

    addChild(enemy)
    activeEnemies.append(enemy)
  }

  private func tossEnemies() {
    guard isGameEnded == false else { return }

    popupTime *= 0.991 // time ramps up
    chainDelay *= 0.99
    physicsWorld.speed *= 1.02

    let sequenceType = sequence[sequencePosition]

    switch sequenceType {
      // one enemy, which IS NOT a bomb
      case .oneNoBomb:
        createEnemy(forceBomb: .never)

      // one enemy, which might be a bomb
      case .one:
        createEnemy()

      // 2 enemies, ONE is a bomb
      case .twoWithOneBomb:
        createEnemy(forceBomb: .never)
        createEnemy(forceBomb: .always)

      case .two:
        createEnemy()
        createEnemy()
      case .three:
        createEnemy()
        createEnemy()
        createEnemy()
      case .four:
        createEnemy()
        createEnemy()
        createEnemy()
        createEnemy()

      case .chain:
        createEnemy()
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
      case .fastChain:
        createEnemy()
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
      case .fastExtraPoints:
        createEnemy(specialSettingsEnemy: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy(specialSettingsEnemy: true) }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy(specialSettingsEnemy: true) }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy(specialSettingsEnemy: true) }
        DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy(specialSettingsEnemy: true) }
    }
    sequencePosition += 1
    print("TOSS SEQUENCE POSTION: \(sequencePosition)")
    nextSequenceQueued = false
  }
}
