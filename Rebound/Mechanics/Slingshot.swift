//
//  Slingshot.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Slingshot: SKShapeNode {
  var thickness = CGFloat()
  var radius = CGFloat()
  var maxStretch = CGFloat()
  
  var sensitivity = CGFloat(10.6)
  var shotVector = CGVector()
  var aimingToPoint = CGPoint()
  var canShoot = Bool(false)
  
  func build() {
    gameScene.addChild(self)
    thickness = gameFrame.width*0.012325
    maxStretch = gameFrame.width*configValueForKey("Max relative slingshot stretch")
    radius = gameScene.ball.radius+thickness/2 + 1
    
    lineWidth = thickness
    lineCap = .square
    strokeColor = currentTheme.slingColor
    zPosition = 4
  }
  
  func aim(_ ball: Ball, atPoint: CGPoint) {
    
    if canShoot {
      alpha = 1
      removeAllActions()
      
      updateSling(ball, atPoint: atPoint)
    }
    
  }
  
  func updateSling(_ ball: Ball, atPoint: CGPoint) {
    
    let stretch = distance(ball.position, p2: atPoint) < maxStretch ? distance(ball.position, p2: atPoint) : maxStretch
    alpha = 0.2 + 0.35*(stretch/maxStretch)
    
    let mutablePath = CGMutablePath()
    mutablePath.move(to: CGPoint(x: radius, y: 0))
    mutablePath.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: radians(0), endAngle: radians(180), clockwise: true)
    mutablePath.addLine(to: CGPoint(x: 0, y: stretch))
    mutablePath.closeSubpath()
    path = mutablePath
    
    zRotation = -atan((atPoint.x-ball.position.x) / (atPoint.y-ball.position.y))
    position = ball.position
    
    shotVector = vectorFromAngleMagnitude(-zRotation, magnitude: stretch/sensitivity)
    let aimVector = vectorFromAngleMagnitude(-zRotation, magnitude: stretch)
    aimingToPoint = CGPoint(x: ball.position.x + aimVector.dx, y: ball.position.y + aimVector.dy)
    
    if atPoint.y < position.y {
      alpha = 0
      shotVector = CGVector(dx: 0, dy: 0)
    }
    
  }
  
  func shoot(_ terrain: Terrain, ball: Ball) -> Bool {
    if canShoot {
      ball.physicsBody?.applyImpulse(shotVector)
    }
    run(SKAction.fadeAlpha(to: 0, duration: 1))
    
    return magnitude(shotVector) > 5.5
  }
  
  func scroll(_ interval: CGFloat, ball: Ball) {
    aimingToPoint.y -= interval
  }
  
  func update(_ terrain: Terrain, ball: Ball) {
    if ball.position.y > aimingToPoint.y {removeAllActions(); alpha = 0}
    if alpha > 0 {updateSling(ball, atPoint: aimingToPoint)}
    if let ballBody = ball.physicsBody {
      if let terrainBody = terrain.physicsBody {
        if ((terrainBody.allContactedBodies().contains(ballBody) && magnitude(ballBody.velocity) < 50) ||
        (terrain is Ring && magnitude(ballBody.velocity) < 65)) ||
        magnitude(ballBody.velocity) < 24
        {canShoot = true}
        else {canShoot = false}
      }
    }
  }
  
}
