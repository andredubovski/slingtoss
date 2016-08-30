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
    maxStretch = gameFrame.height*0.32
    radius = gameScene.ball.radius+thickness/2 + 1
    
    lineWidth = thickness
    zPosition = 4
  }
  
  func aim(ball: Ball, atPoint: CGPoint) {
    
    alpha = 1
    removeAllActions()
    ball.physicsBody?.resting = true
    
    updateSling(ball, atPoint: atPoint)
    
  }
  
  func updateSling(ball: Ball, atPoint: CGPoint) {
    
    let stretch = distance(ball.position, p2: atPoint) < maxStretch ? distance(ball.position, p2: atPoint) : maxStretch
    alpha = 0.2 + 0.35*(stretch/maxStretch)
    
    let mutablePath = CGPathCreateMutable()
    CGPathMoveToPoint(mutablePath, nil, radius, 0)
    CGPathAddArc(mutablePath, nil, 0, 0, radius, radians(0), radians(180), true)
    CGPathAddLineToPoint(mutablePath, nil, 0, stretch)
    CGPathCloseSubpath(mutablePath)
    path = mutablePath
    
    zRotation = -atan((atPoint.x-ball.position.x) / (atPoint.y-ball.position.y))
    position = ball.position
    
    shotVector = vectorFromAngleMagnitude(-zRotation, magnitude: stretch/sensitivity)
    let aimVector = vectorFromAngleMagnitude(-zRotation, magnitude: stretch)
    aimingToPoint = CGPointMake(ball.position.x + aimVector.dx, ball.position.y + aimVector.dy)
    
    if atPoint.y < position.y {
      alpha = 0
      shotVector = CGVectorMake(0, 0)
    }
    
  }
  
  func shoot(ball: Ball) {
    if canShoot {ball.physicsBody?.applyImpulse(shotVector)}
    runAction(SKAction.fadeAlphaTo(0, duration: 1))
    
    if magnitude(shotVector) > 5.5 {gameScene.terrains.array[gameScene.score.amount].fall()}
  }
  
  func scroll(interval: CGFloat, ball: Ball) {
    aimingToPoint.y -= interval
  }
  
  func update(ball: Ball) {
    if ball.position.y > aimingToPoint.y {removeAllActions(); alpha = 0}
    if alpha > 0 {updateSling(ball, atPoint: aimingToPoint)}
    if ball.physicsBody?.velocity.dy < 1 && magnitude((ball.physicsBody?.velocity)!) < 30 {
      canShoot = true
    } else {canShoot = false}
  }
  
}
