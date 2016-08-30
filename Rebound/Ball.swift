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
    
    radius = gameFrame.width*0.026
    path = CGPathCreateWithEllipseInRect(CGRectMake(-radius, -radius, radius*2, radius*2), nil)
    position = CGPointMake(gameFrame.midX, gameFrame.height*0.4)
    fillColor = SKColor.redColor()
    lineWidth = 1
    strokeColor = fillColor
    zPosition = 3
    
    physicsBody = SKPhysicsBody(circleOfRadius: radius)
    physicsBody?.categoryBitMask = PhysicsCategory.Ball
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
    position.y = gameFrame.height*0.4
  }
  
  func update(terrains: TerrainController) {
    if physicsBody?.velocity.dy > 0 {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
    } else {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
    }
    
    if terrains.containPoint(CGPointMake(position.x, position.y-(radius*0.8))) ||
      terrains.containPoint(CGPointMake(position.x, position.y+(radius*0.8))) ||
      terrains.containPoint(CGPointMake(position.x-(radius*0.8), position.y)) ||
      terrains.containPoint(CGPointMake(position.x+(radius*0.8), position.y)){
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
    }
  
    if let platformBody = terrains.current.physicsBody {
      if terrains.current.doesMove {
        self.physicsBody?.velocity.dx = (platformBody.velocity.dx)
      }
    }
  }
}
