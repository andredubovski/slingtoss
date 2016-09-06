//
//  Ball.swift
//  Rebound
//  
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Ball: SKShapeNode {
  var radius = CGFloat()
  
  func build() {
    
    radius = gameFrame.width * configValueForKey("Relative ball radius")
    path = CGPathCreateWithEllipseInRect(CGRectMake(-radius, -radius, radius*2, radius*2), nil)
    position = CGPointMake(gameFrame.midX, gameFrame.height*0.4)
    fillColor = currentTheme.ballColor
    lineWidth = 1
    strokeColor = fillColor
    zPosition = 3
    
    physicsBody = SKPhysicsBody(circleOfRadius: radius)
    physicsBody?.categoryBitMask = PhysicsCategory.Ball
    physicsBody?.dynamic = true
    physicsBody!.mass = pow(0.000000305*gameFrame.height, 0.5)
    physicsBody!.angularDamping = 4
    physicsBody?.usesPreciseCollisionDetection = true
    
    gameScene.addChild(self)
  
  }
  
  func scroll(interval: CGFloat) {
    position.y -= interval
  }
  
  func reset() {
    physicsBody?.resting = true
    position.y = gameFrame.height*0.32
  }
  
  func update(terrains: TerrainController) {
    if physicsBody?.velocity.dy < 0 || (physicsBody?.velocity.dy < 30 && terrains.current is Ring) {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
    } else {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
    }
    
    if terrains.containPoint(CGPointMake(position.x, position.y-(radius-1.5))) ||
      terrains.containPoint(CGPointMake(position.x, position.y+(radius-1.5))) ||
      terrains.containPoint(CGPointMake(position.x-(radius-1.5), position.y)) ||
      terrains.containPoint(CGPointMake(position.x+(radius-1.5), position.y)){
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
    }
    
    if gameScene.menu.isActive || gameScene.deathMenu.isActive {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
    }
    
    
  
  }
}
