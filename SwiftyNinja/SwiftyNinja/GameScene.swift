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
}

class GameScene: SKScene {
  var gameScore: SKLabelNode!
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

    sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

    for _ in 0 ... 1000 {
      if let nextSequence = SequenceType.allCases.randomElement() {
        sequence.append(nextSequence)
      }
    }

    // start creating enemies after 2 seconds have passed
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
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

        score += 1

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
    activeSlicePoints.removeAll(keepingCapacity: true)

    let location = touch.location(in: self)
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
        if node.position.y < -140 {
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
    isUserInteractionEnabled = false

    bombSoundEffect?.stop()
    bombSoundEffect = nil

    // change all lifes to gone
    if triggeredByBomb {
      livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
      livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
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
  private func createEnemy(forceBomb: ForceBomb = .random) {
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
    }
    // position code
    let randomPosition = CGPoint(x: Int.random(in: 64 ... 960), y: -128)
    enemy.position = randomPosition

    // rotation velocity
    let randomAngularVelocity = CGFloat.random(in: -3 ... 3)
    // movement speed
    let randomXVelocity: Int
    // way to the left
    if randomPosition.x < 256 {
      randomXVelocity = Int.random(in: 8 ... 15)
      // to the left
    } else if randomPosition.x < 512 {
      randomXVelocity = Int.random(in: 3 ... 5)
      // to the right
    } else if randomPosition.x < 768 {
      randomXVelocity = -Int.random(in: 3 ... 5)
      // way to the right
    } else {
      randomXVelocity = -Int.random(in: 8 ... 15)
    }

    let randomYVelocity = Int.random(in: 24 ... 32)

    // physics body, half sprite size (128 -> 64)
    enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
    enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
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
    }
    sequencePosition += 1
    nextSequenceQueued = false
  }
}
