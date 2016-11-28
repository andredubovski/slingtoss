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
  var next = Terrain()
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
      isPermeable: true,
      doesMoveDown: false,
      movingDownSpeed: 0,
      doesMoveAcross: false,
      movingAcrossSpeed: 0,
      lengthRelativeToFrameWidth: random(0.3, to: 0.35),
      edgeHeightRelativeToFrameWidth: configNumberForKey("Default relative platform edge height"),
      relativePositionAbovePrevious: CGPoint(x: CGFloat(Int(random(1, to: 3))) / 3.0, y: 1/3)
    )
    
    makeRandomTerrain(difficulty: 0.01)
    array[array.count-1]!.alpha = 0
    array[array.count-1]!.hasAppeared = true
    
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
          if let n = array[gameScene.score.amount+1] {
            next = n
          }
        }
        if terrain.position.y < -gameFrame.height {
          array[i]?.removeFromParent()
        }
      }
    }
    
    difficulty = pow(CGFloat(array.count)+25, 1/3)/3.3 - 0.88
    difficulty = difficulty*0.8 + random(0, to: 0.2)
    if difficulty < 0 {difficulty = 0}
    else if difficulty > 1 {difficulty = 1}
    
    if array[array.count-1]!.position.y < gameFrame.height*2 {
      makeRandomTerrain(difficulty: difficulty)
    }

  }
  
  func update(ball: Ball) {
    
    if ball.isLandedOnTerrain {
      
      if current.doesMoveDown &&
        !current.isMovingDown {
        current.beginMovingDown()
      }
      
      if current.doesMoveAcross &&
        current.isMovingAcross {
        current.stopMovingAcross()
      }
      
    }
    
  }
  
  
  func makePlatform(isPermeable: Bool, doesMoveDown: Bool, movingDownSpeed: CGFloat, doesMoveAcross: Bool, movingAcrossSpeed: CGFloat, lengthRelativeToFrameWidth: CGFloat, edgeHeightRelativeToFrameWidth: CGFloat, relativePositionAbovePrevious: CGPoint) {
    
    let length = lengthRelativeToFrameWidth*gameFrame.width
    let height = edgeHeightRelativeToFrameWidth*gameFrame.width
    
    let position = CGPoint(x: relativePositionAbovePrevious.x*gameFrame.width, y: array[array.count-1]!.position.y + relativePositionAbovePrevious.y*gameFrame.height)
    
    let newPlatform = Platform(length: length, height: height, position: position)
    newPlatform.isPermeable = isPermeable
    newPlatform.doesMoveDown = doesMoveDown
    newPlatform.movingDownSpeed = movingDownSpeed
    newPlatform.doesMoveAcross = doesMoveAcross
    newPlatform.movingAcrossSpeed = movingAcrossSpeed
    array.append(newPlatform)
    newPlatform.build()
    newPlatform.makeSureIsInFrame()
  }
  
  
  func makeRing(doesMoveAcross: Bool, movingAcrossSpeed: CGFloat, radiusRelativeToFrameWidth: CGFloat, relativePositionAbovePrevious: CGPoint) {
    var radius = CGFloat()
    var position = CGPoint()
    
    radius = radiusRelativeToFrameWidth*gameFrame.width
    
    position = CGPoint(x: relativePositionAbovePrevious.x*gameFrame.width, y: array[array.count-1]!.position.y + relativePositionAbovePrevious.y*gameFrame.height)
    
    let newRing = Ring(radius: radius, position: position)
    newRing.doesMoveAcross = doesMoveAcross
    newRing.movingAcrossSpeed = movingAcrossSpeed
    array.append(newRing)
    newRing.build()
    newRing.makeSureIsInFrame()
  }
  
  
  func makeRandomTerrain(difficulty: CGFloat = 0.5) {
  
    var position = CGPoint(x: random(0, to: 1), y: weightedRandom(1/3, to: 2/3, weight: difficulty))
    
    let doesMoveAcross = weightedRandom(0, to: 100, weight: difficulty) > 66
    let movingAcrossSpeed = weightedRandom(0, to: 1, weight: difficulty)
  
    if random(0, to: 4) > 1 {
      
      var moves = weightedRandom(0, to: 100, weight: difficulty) > 69
      let movingSpeed = weightedRandom(0, to: 1, weight: difficulty)
      
      var permeable = !(weightedRandom(0, to: 100, weight: difficulty) > 63.5)
      
      if let lastPlatform = array[array.count-1] as? Platform {
        if lastPlatform.doesMoveDown {
          permeable = true
          if weightedRandom(0, to: 100, weight: difficulty) > 35 {
            moves = true
          }
        }
      }
      
      let length = weightedRandom(minLength, to: maxLength, weight: 1-difficulty)
      let height = weightedRandom(minHeight, to: maxHeight, weight: 1-difficulty)
      
      if !permeable {
        position = CGPoint(x: random(0, to: 1), y: weightedRandom(1/3, to: 1/2, weight: difficulty))
      }
      
      makePlatform(isPermeable: permeable,
                   doesMoveDown: moves,
                   movingDownSpeed: movingSpeed,
                   doesMoveAcross: doesMoveAcross,
                   movingAcrossSpeed: movingAcrossSpeed,
                   lengthRelativeToFrameWidth: length,
                   edgeHeightRelativeToFrameWidth: height,
                   relativePositionAbovePrevious: position)
      
    } else {
      
      let radius = weightedRandom(minRadius, to: maxRadius, weight: 1-difficulty)
      makeRing(doesMoveAcross: doesMoveAcross, movingAcrossSpeed: movingAcrossSpeed, radiusRelativeToFrameWidth: radius, relativePositionAbovePrevious: position)
      
    }
    
  }
  
  
  func containPoint(_ point: CGPoint) -> Bool {
    if current.contains(point) {return true}
    if let next = array[gameScene.score.amount+1] {
      if next.contains(point) {return true}
    }
    return false
  }
}
