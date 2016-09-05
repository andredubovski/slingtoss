//
//  Terrain.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Terrain: SKShapeNode {
  
  var thickness = CGFloat()
  var hasScored = Bool(false)
  var hasFallen = Bool(false)
  var hasAppeared = Bool(false)
  
  var isPermeable = Bool(true)
  
  override init() {
    
    thickness = gameFrame.width*0.046875
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func build(isEdgeBody: Bool, path: CGPath?) {
    
    if let p = path {physicsBody = isEdgeBody ? SKPhysicsBody(polygonFromPath: p) : SKPhysicsBody(edgeLoopFromPath: p)}
    else {physicsBody = isEdgeBody ? SKPhysicsBody(polygonFromPath: self.path!) : SKPhysicsBody(edgeLoopFromPath: self.path!)}
    physicsBody?.dynamic = false
    physicsBody?.restitution = 0.4
    physicsBody?.mass = 0.22
    physicsBody?.categoryBitMask = isPermeable ? PhysicsCategory.Terrain : PhysicsCategory.ImpermeableTerrain
    
    strokeColor = fillColor
    
    gameScene.addChild(self)
    
  }
  
  func build() {
    build(false, path: nil)
  }
  
  func appear() {
    hasAppeared = true
    let popOut = SKAction.sequence([
      SKAction.scaleTo(0, duration: 0),
      SKAction.scaleTo(1.2, duration: 0.4),
      SKAction.scaleTo(1, duration: 0.1)
      ])
    
    runAction(popOut)
  }
  
  func fall() {
    physicsBody?.linearDamping = 0.1
    physicsBody?.angularDamping = 0.1
    physicsBody?.dynamic = true
    physicsBody?.affectedByGravity = true
    physicsBody?.applyAngularImpulse(random(-100, to: 100) > 0 ? -0.027 : 0.027)
    hasFallen = true
  }
  
  func makeSureIsInFrame() {
    if position.x < frame.width/2 {position.x = frame.width/2}
    if position.x > gameFrame.width-frame.width/2 {position.x = gameFrame.width-frame.width/2}
  }
  
  func beginMovingDown() {
    physicsBody?.dynamic = true
    physicsBody?.affectedByGravity = true
    physicsBody?.linearDamping = 100
    physicsBody?.angularDamping = 15
  }
  
}
