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
  var doesCollideWithPermeableTerrains = Bool(false)
  var isContactingTerrain = Bool(false)
  var isLandedOnTerrain = Bool(false)
  var timeOfLastShot = TimeInterval()
  
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
    
    physicsBody = SKPhysicsBody(circleOfRadius: radius-0.5)
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
    if (physicsBody?.velocity.dy <= 50 ||
      (physicsBody?.velocity.dy <= 75 &&
        terrains.current is Ring &&
        NSDate().timeIntervalSince1970 - timeOfLastShot > 0.5)) &&
      
      !(terrains.containPoint(CGPoint(x: position.x, y: position.y-(radius-2))) ||
        terrains.containPoint(CGPoint(x: position.x, y: position.y+(radius-2))) ||
        terrains.containPoint(CGPoint(x: position.x-(radius-2), y: position.y)) ||
        terrains.containPoint(CGPoint(x: position.x+(radius-2), y: position.y)) ||
        
        terrains.containPoint(CGPoint(x: position.x + (radius-3)/pow(2, 0.5), y: position.y + (radius-3)/pow(2, 0.5))) ||
        terrains.containPoint(CGPoint(x: position.x + (radius-3)/pow(2, 0.5), y: position.y - (radius-3)/pow(2, 0.5))) ||
        terrains.containPoint(CGPoint(x: position.x - (radius-3)/pow(2, 0.5), y: position.y + (radius-3)/pow(2, 0.5))) ||
        terrains.containPoint(CGPoint(x: position.x - (radius-3)/pow(2, 0.5), y: position.y - (radius-3)/pow(2, 0.5)))) {
      
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
      doesCollideWithPermeableTerrains = true
      
    } else {
      
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain
      doesCollideWithPermeableTerrains = false
      
    }
    
    if gameScene.menu.isActive || gameScene.deathMenu.isActive {
      physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.ImpermeableTerrain | PhysicsCategory.Terrain
      doesCollideWithPermeableTerrains = true
    }
    
    var isContactingTerrain = Bool(false)
    for contactedBody in (physicsBody?.allContactedBodies())! {
      if contactedBody.categoryBitMask == PhysicsCategory.Terrain ||
        contactedBody.categoryBitMask == PhysicsCategory.ImpermeableTerrain {
        isContactingTerrain = true
      }
    }
    self.isContactingTerrain = isContactingTerrain
    
    
    if doesCollideWithPermeableTerrains && isContactingTerrain {
      
      if let nextTerrainPhysicsBody = terrains.next.physicsBody {
        if abs(magnitude(nextTerrainPhysicsBody.velocity) - magnitude(physicsBody!.velocity)) < 70 ||
          abs(magnitude(terrains.next.physicsBody!.velocity) - magnitude(physicsBody!.velocity)) < 70 {
          isLandedOnTerrain = true
        } else {
          isLandedOnTerrain = false
        }
        return
      }
        
      else if abs(magnitude(terrains.current.physicsBody!.velocity) - magnitude(physicsBody!.velocity)) < 70 {
        isLandedOnTerrain = true
      } else {
        isLandedOnTerrain = false
      }
      
    }
   
    else {
      isLandedOnTerrain = false
    }
    
  }
}
