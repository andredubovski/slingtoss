//
//  terrains.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit

class TerrainController {
  var array = [Terrain?]()
  var current = Terrain()
  var currentIndex = Int()
  var minLength = CGFloat()
  var maxLength = CGFloat()
  var minHeight = CGFloat()
  var maxHeight = CGFloat()
  var minRadius = CGFloat()
  var maxRadius = CGFloat()
  
  var difficulty = CGFloat()
  
  init() {
  }
  
  func build() {
    minLength = configNumberForKey("Min relative platform length")
    maxLength = configNumberForKey("Max relative platform length")
    minHeight = configNumberForKey("Min relative platform edge height")
    maxHeight = configNumberForKey("Max relative platform edge height")
    minRadius = configNumberForKey("Min relative ring radius")
    maxRadius = configNumberForKey("Max relative ring radius")
  }
  
  
  func scroll(_ interval: CGFloat, progress: CGFloat, ball: Ball, score: Score) {
    for i in 0...array.count-1 {
      if let terrain = array[i] {
        terrain.position.y -= interval
        if (terrain.position.y < gameFrame.height && !terrain.hasAppeared) ||
          (i == 2 && !terrain.hasAppeared) {terrain.appear()}
        if terrain is Platform  {if terrain.position.y < 0 && !terrain.hasFallen {terrain.fall()}}
        if terrain is Ring  {if terrain.position.y < -terrain.frame.height/2 && !terrain.hasFallen {terrain.fall()}}
        if (terrain.position.y + (terrain.thickness + ball.frame.height/2) - 2.5 <= ball.position.y &&
          !((terrain.physicsBody?.allContactedBodies().contains(ball.physicsBody!))!))
          &&
          !terrain.hasScored {
          terrain.scoreOn(score)
          current = array[score.amount]!
          currentIndex = score.amount
        }
        if terrain.position.y < -gameFrame.height {
          array[i]?.removeFromParent()
        }
      }
    }
    
    difficulty = pow(CGFloat(score.amount)+25, 1/3)/3 - 0.77
//    let d = log2(Double(array.count) - 7) / 8
//    if d.isNaN {difficulty = 0}
//    else {difficulty = CGFloat(d)}
    if difficulty < 0 {difficulty = 0}
    else if difficulty > 1 {difficulty = 1}
    
    if array[array.count-1]!.position.y < gameFrame.height*2 {
      makeRandomTerrain(difficulty)
    } 
  }
  
  func update(ball: Ball) {
    
    if ball.physicsBody!.velocity.dy < 40 &&
      ball.physicsBody!.velocity.dy < 6 &&
      current.doesMoveDown &&
      !current.isMovingDown {
      current.beginMovingDown()
    }
    
  }
  
  
  func makePlatform(_ willBePermeable: Bool, willMove: Bool, movingDownSpeed: CGFloat, lengthRelativeToFrameWidth: CGFloat, edgeHeightRelativeToFrameWidth: CGFloat, relativePositionAbovePrevious: CGPoint) {
    
    let length = lengthRelativeToFrameWidth*gameFrame.width
    let height = edgeHeightRelativeToFrameWidth*gameFrame.width
    
    let position = CGPoint(x: relativePositionAbovePrevious.x*gameFrame.width, y: array[array.count-1]!.position.y + relativePositionAbovePrevious.y*gameFrame.height)
    
    let newPlatform = Platform(length: length, height: height, position: position)
    newPlatform.isPermeable = willBePermeable
    newPlatform.doesMoveDown = willMove
    newPlatform.movingDownSpeed = movingDownSpeed
    array.append(newPlatform)
    newPlatform.build()
    newPlatform.makeSureIsInFrame()
  }
  
  
  func makeRing(_ willMove: Bool?, radiusRelativeToFrameWidth: CGFloat, relativePositionAbovePrevious: CGPoint) {
    var radius = CGFloat()
    var position = CGPoint()
    let doesMove = false
    
    radius = radiusRelativeToFrameWidth*gameFrame.width
    
    position = CGPoint(x: relativePositionAbovePrevious.x*gameFrame.width, y: array[array.count-1]!.position.y + relativePositionAbovePrevious.y*gameFrame.height)
    
    let newRing = Ring(radius: radius, position: position)
    newRing.doesMoveDown = doesMove
    array.append(newRing)
    newRing.build()
    newRing.makeSureIsInFrame()
  }
  
  
  func makeRandomTerrain(_ difficulty: CGFloat = 0.5) {
  
    var position = CGPoint(x: random(0, to: 1), y: weightedRandom(1/3, to: 2/3, weight: difficulty))
  
    if random(0, to: 4) > 1 {
      
      var moving = weightedRandom(0, to: 100, weight: difficulty) > 69
      let movingSpeed = weightedRandom(0, to: 1, weight: difficulty)
      
      var permeable = !(weightedRandom(0, to: 100, weight: difficulty) > 63.5)
      
      if let lastPlatform = array[array.count-1] as? Platform {
        if lastPlatform.doesMoveDown {
          permeable = true
          if weightedRandom(0, to: 100, weight: difficulty) > 35 {
            moving = true
          }
        }
      }
      
      let length = weightedRandom(minLength, to: maxLength, weight: 1-difficulty)
      let height = weightedRandom(minHeight, to: maxHeight, weight: 1-difficulty)
      
      if !permeable {
        position = CGPoint(x: random(0, to: 1), y: weightedRandom(1/3, to: 1/2, weight: difficulty))
      }
      
      makePlatform(permeable,
                   willMove: moving,
                   movingDownSpeed: movingSpeed,
                   lengthRelativeToFrameWidth: length,
                   edgeHeightRelativeToFrameWidth: height,
                   relativePositionAbovePrevious: position)
      
    } else {
      
      let radius = weightedRandom(minRadius, to: maxRadius, weight: 1-difficulty)
      makeRing(false, radiusRelativeToFrameWidth: radius, relativePositionAbovePrevious: position)
      
    }
    
  }
  
  
  func reset(_ ball: Ball, menu: MainMenu) {
    for (iT, t) in array.enumerated() {
      if let terrain = t {terrain.removeFromParent()}
      array[iT] = nil
    }
    array.removeAll()
    
    let firstPlatform = Platform(length: gameFrame.width*0.3, position: CGPoint(x: ball.position.x, y: gameFrame.height/12))
    firstPlatform.build()
    firstPlatform.hasScored = true
    firstPlatform.makeSureIsInFrame()
    current = firstPlatform
    array.append(firstPlatform)
    
    makePlatform(
      true,
      willMove: false,
      movingDownSpeed: 0,
      lengthRelativeToFrameWidth: random(0.3, to: 0.35),
      edgeHeightRelativeToFrameWidth: configNumberForKey("Default relative platform edge height"),
      relativePositionAbovePrevious: CGPoint(x: CGFloat(Int(random(1, to: 3))) / 3.0, y: 1/3)
    )
    
    makeRandomTerrain(0.01)
    array[array.count-1]!.alpha = 0
    array[array.count-1]!.hasAppeared = true
    
  }
  
  
  func containPoint(_ point: CGPoint) -> Bool {
    if current.contains(point) {return true}
    if let next = array[gameScene.score.amount+1] {if next.contains(point) {return true}}
    return false
  }
}