//
//  terrains.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class TerrainController {
  var array = [Terrain?]()
  var current = Terrain()
  var currentIndex = Int()
  var minLength = CGFloat()
  var maxLength = CGFloat()
  var minRadius = CGFloat()
  var maxRadius = CGFloat()
  
  init() {
  }
  
  func build() {
    minLength = gameFrame.width * configValueForKey("Min relative platform length")
    maxLength = gameFrame.width * configValueForKey("Max relative platform length")
    minRadius = gameFrame.width * configValueForKey("Min relative ring radius")
    maxRadius = gameFrame.width * configValueForKey("Max relative ring radius")
  }
  
  
  func scroll(interval: CGFloat, progress: CGFloat, ball: Ball, score: Score) {
    for i in 0...array.count-1 {
      if let terrain = array[i] {
        terrain.position.y -= interval
        if terrain.position.y < gameFrame.height && !terrain.hasAppeared {terrain.appear()}
        if terrain is Platform  {if terrain.position.y < 0 && !terrain.hasFallen {terrain.fall()}}
        if terrain is Ring  {if terrain.position.y < -terrain.frame.height/2 && !terrain.hasFallen {terrain.fall()}}
        if (terrain.position.y + (terrain.thickness + ball.frame.height/2) - 2.5 <= ball.position.y &&
          !((terrain.physicsBody?.allContactedBodies().contains(ball.physicsBody!))!))
          &&
          !terrain.hasScored {
          terrain.scoreOn(score)
          current = array[score.amount]!
          currentIndex = score.amount
          if current.doesMoveDown {current.beginMovingDown()}
        }
        if terrain.position.y < -gameFrame.height {
          array[i] = nil
        }
      }
    }
    
    if array[array.count-1]!.position.y < gameFrame.height*2 {
      makeRandomTerrain()
    }
  }
  
  
  func makePlatform(willBePermeable: Bool? = nil, willMove: Bool? = nil, lengthRelativeToFrameWidth: CGFloat? = nil, relativePositionAbovePrevious: CGPoint? = nil) {
    
    var isPermeable = Int(random(0, to: 5)) != 0
    var doesMove = !(Int(random(0, to: 4)) != 0)
    var newLength = random(minLength, to: maxLength)
    var position = CGPoint()
    
    if let permeable = willBePermeable {
      isPermeable = permeable
    }
    
    if isPermeable {
      position = CGPointMake(random(0, to: gameFrame.width),
                             array[array.count-1]!.position.y + random(gameFrame.height/3, to: 2*gameFrame.height/3))
    } else {
      position = CGPointMake(random(0, to: gameFrame.width),
                             array[array.count-1]!.position.y + random(gameFrame.height/3, to: gameFrame.height/2))
    }
    
    if let moves = willMove {
      doesMove = moves
    }
    
    if let length = lengthRelativeToFrameWidth {
      newLength = length*gameFrame.width
    }
    
    if let pos = relativePositionAbovePrevious {
      position = CGPointMake(pos.x*gameFrame.width, array[array.count-1]!.position.y + pos.y*gameFrame.height)
    }
    
    let newPlatform = Platform(length: newLength, position: position)
    newPlatform.isPermeable = isPermeable
    newPlatform.doesMoveDown = doesMove
    array.append(newPlatform)
    newPlatform.build()
    
    newPlatform.makeSureIsInFrame()
  }
  
  
  func makeRing(willMove: Bool? = nil, radiusRelativeToFrameWidth: CGFloat? = nil, relativePositionAbovePrevious: CGPoint? = nil) {
    var newRadius = random(minRadius, to: maxRadius)
    var position = CGPoint()
    let doesMove = false
    
    position = CGPointMake(random(0, to: gameFrame.width),
                           array[array.count-1]!.position.y + random(gameFrame.height/3, to: gameFrame.height/2))
    
    if let radius = radiusRelativeToFrameWidth {
      newRadius = radius*gameFrame.width
    }
    
    if let pos = relativePositionAbovePrevious {
      position = CGPointMake(pos.x*gameFrame.width, array[array.count-1]!.position.y + pos.y*gameFrame.height)
    }
    
    let newRing = Ring(radius: newRadius, position: position)
    newRing.doesMoveDown = doesMove
    array.append(newRing)
    newRing.build()
    
    newRing.makeSureIsInFrame()
  }
  
  
  func makeRandomTerrain() {
    
    var moving = Bool?()
    moving = nil
    var permeable = Bool?()
    permeable = nil
    
    if let lastTerrain = array[array.count-1] {
      if lastTerrain.doesMoveDown {
        if random(0, to: 1.3) < 1 {
          makePlatform(permeable, willMove: true)
        }
      }
    }
    
    if let lastPlatform = array[array.count-1] as? Platform {
      if lastPlatform.isPermeable {
        permeable = false
      }
    }
    
    if random(0, to: 1.5) > 1 {
      makePlatform(permeable, willMove: moving)
    } else {
      makeRing(moving)
    }
    
  }
  
  
  func reset(ball: Ball, menu: MainMenu) {
    for p in array {
      if let platform = p {platform.removeFromParent()}
    }
    array.removeAll()
    
    let firstPlatform = Platform(length: gameFrame.width*0.3, position: CGPointMake(ball.position.x, gameFrame.height/12))
    firstPlatform.build()
    firstPlatform.hasScored = true
    firstPlatform.makeSureIsInFrame()
    current = firstPlatform
    array.append(firstPlatform)
    
    makePlatform(
      true,
      willMove: false,
      lengthRelativeToFrameWidth: random(0.15, to: 0.25),
      relativePositionAbovePrevious: CGPointMake(CGFloat(Int(random(1, to: 3))) / 3.0, 1/3)
    )
    
    makePlatform(
      true,
      lengthRelativeToFrameWidth: random(0.25, to: 0.35),
      relativePositionAbovePrevious: CGPointMake(random(0, to: 1), random(0.6, to: 0.66))
    )
  }
  
  
  func containPoint(point: CGPoint) -> Bool {
    if current.containsPoint(point) {return true}
    if let next = array[gameScene.score.amount+1] {if next.containsPoint(point) {return true}}
    return false
  }
}
