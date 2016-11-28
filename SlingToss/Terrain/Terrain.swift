//
//  Terrain.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit

class Terrain: SKShapeNode {
  
  var thickness = CGFloat()
  var hasScored = Bool(false)
  var hasFallen = Bool(false)
  var hasAppeared = Bool(false)
  
  var isPermeable = Bool(true)
  var doesMoveDown = Bool(false)
  var movingDownSpeed = CGFloat(0)
  var isMovingDown = Bool(false)
  var doesMoveAcross = Bool(false)
  var movingAcrossSpeed = CGFloat(0.5)
  var isMovingAcross = Bool(true)
  
  override init() {
    
    thickness = gameFrame.width * configNumberForKey("Relative terrain thickness")
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func build() {
    
    zPosition = 2.5
    physicsBody = SKPhysicsBody(polygonFrom: self.path!)
    physicsBody?.isDynamic = false
    physicsBody?.restitution = 0.4
    physicsBody?.mass = 0.22
    physicsBody?.categoryBitMask = isPermeable ? PhysicsCategory.Terrain : PhysicsCategory.ImpermeableTerrain
    physicsBody?.contactTestBitMask = PhysicsCategory.Ball
    physicsBody?.usesPreciseCollisionDetection = true
    
    if doesMoveDown {strokeColor = currentTheme.movingDownPlatformStrokeColor; lineWidth = 2; glowWidth = 0.5}
    else {strokeColor = fillColor}
    
    if doesMoveAcross {
      let moveAcrossDuration = TimeInterval(6 - movingAcrossSpeed*3.5)
      let moveAcrossAction = SKAction.repeatForever(SKAction.sequence([
        SKAction.moveTo(x: gameFrame.width-frame.width/2, duration: moveAcrossDuration),
        SKAction.moveTo(x: frame.width/2, duration: moveAcrossDuration)
        ]))
//      setValue(moveAcrossAction, forKey: "move across")
      position.x = frame.width/2
      run(moveAcrossAction)
    }
    
    gameScene.addChild(self)
    
  }
  
  func appear() {
    let popOut = SKAction.group([SKAction.sequence([
      SKAction.scale(to: 0, duration: 0),
      SKAction.scale(to: 1.2, duration: 0.24),
      SKAction.scale(to: 1, duration: 0.06)
      ]),
      SKAction.fadeAlpha(to: 1, duration: 0.3)
  ])
  
    run(popOut)
    hasAppeared = true
  }
  
  func fall() {
    physicsBody?.linearDamping = 0.1
    physicsBody?.angularDamping = 0.1
    physicsBody?.isDynamic = true
    physicsBody?.affectedByGravity = true
    physicsBody?.applyAngularImpulse(random(-100, to: 100) > 0 ? -0.03 : 0.03)
    hasFallen = true
  }
  
  func makeSureIsInFrame() {
    if position.x < frame.width/2 {position.x = frame.width/2}
    if position.x > gameFrame.width-frame.width/2 {position.x = gameFrame.width-frame.width/2}
  }
  
  func beginMovingDown() {
    physicsBody?.isDynamic = true
    physicsBody?.affectedByGravity = true
    physicsBody?.linearDamping = 75 + (1-movingDownSpeed)*90
    physicsBody?.angularDamping = 14 + (1-movingDownSpeed)*10
  }
  
  func stopMovingAcross() {
//    removeAction(forKey: "move across")
    removeAllActions()
    isMovingAcross = false
  }
  
  func scoreOn(_ score: Score) {
    score.increment()
    hasScored = true
  }
  
}
