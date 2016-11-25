//
//  Ball.swift
//  SlingToss
//  
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class Ball: SKSpriteNode {
  var radius = CGFloat()
  var collidingWithPermeable = Bool()
  
  func build() {
    
    name = "ball"
    radius = gameFrame.width * configNumberForKey("Relative ball radius")
    size = CGSize(width: radius*2, height: radius*2)
    texture = SKTexture(image: #imageLiteral(resourceName: "ball"))
//    path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)
    position = CGPoint(x: gameFrame.midX, y: gameFrame.height*0.4)
//    fillColor = currentTheme.ballColor
//    lineWidth = 1
//    strokeColor = fillColor
    zPosition = 3
    
    physicsBody = SKPhysicsBody(circleOfRadius: radius)
    physicsBody?.categoryBitMask = PhysicsCategory.Ball
    physicsBody?.contactTestBitMask = PhysicsCategory.Terrain | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Wall
    physicsBody?.isDynamic = true
    physicsBody!.mass = 0.013162067
    physicsBody?.linearDamping = 0.100000001490116
    physicsBody!.angularDamping = 4
    physicsBody?.usesPreciseCollisionDetection = true
    
    gameScene.addChild(self)
  
  }
  
  func scroll(_ interval: CGFloat) {
    position.y -= interval
  }
  
  func reset() {
    physicsBody?.isResting = true
    position.y = gameFrame.height*0.32
  }
  
  func update(_ terrains: TerrainController) {
    if physicsBody?.velocity.dy <= 50 &&
      !(terrains.containPoint(CGPoint(x: position.x, y: position.y-(radius-1.5))) ||
        terrains.containPoint(CGPoint(x: position.x, y: position.y+(radius-1.5))) ||
        terrains.containPoint(CGPoint(x: position.x-(radius-1.5), y: position.y)) ||
        terrains.containPoint(CGPoint(x: position.x+(radius-1.5), y: position.y))) {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
      collidingWithPermeable = true
    } else {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
      collidingWithPermeable = false
    }
    
    if gameScene.menu.isActive || gameScene.deathMenu.isActive {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
      collidingWithPermeable = true
    }
  
  }
}
