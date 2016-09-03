//
//  terrains.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class TerrainController {
  var array = [Terrain]()
  var current = Terrain()
  var minLength = CGFloat()
  var maxLength = CGFloat()
  
  init() {
  }
  
  func build() {
    minLength = gameFrame.width*0.15
    maxLength = gameFrame.width*0.35
  }
  
  
  func scroll(interval: CGFloat, progress: CGFloat, ball: Ball, score: Score) {
    for platform in array {
      platform.position.y -= interval
      if platform.position.y < gameFrame.height && !platform.hasAppeared {platform.appear()}
      if platform.position.y < 0 && !platform.hasFallen {platform.fall()}
      if platform.position.y < ball.position.y && !platform.hasScored {
        score.increment()
        platform.hasScored = true

        current = array[score.amount]
      }
    }
    
    if Int(progress/(gameFrame.height/3) + 5) > array.count {
      makePlatform()
    }
  }
  

  func makePlatform(willBePermeable: Bool?, lengthRelativeToFrameWidth: CGFloat?, relativePositionAbovePrevious: CGPoint?) {
    var isPermeable = Int(random(0, to: 5)) != 0
    var newLength = random(minLength, to: maxLength)
    var position = CGPoint()
    
    if isPermeable {
      position = CGPointMake(random(0, to: gameFrame.width),
                                array[array.count-1].position.y + random(gameFrame.height/3, to: 2*gameFrame.height/3))
    } else {
      position = CGPointMake(random(0, to: gameFrame.width),
                                array[array.count-1].position.y + random(gameFrame.height/3, to: gameFrame.height/2))
    }
    
    if let permeable = willBePermeable {
      isPermeable = permeable
    }
    
    if let length = lengthRelativeToFrameWidth {
      newLength = length*gameFrame.width
    }
    
    if let pos = relativePositionAbovePrevious {
      position = CGPointMake(pos.x*gameFrame.width, array[array.count-1].position.y + pos.y*gameFrame.height)
    }
    
    let newPlatform = Platform(length: newLength, position: position)
    newPlatform.isPermeable = isPermeable
    array.append(newPlatform)
    newPlatform.build()
    
    newPlatform.makeSureIsInFrame()
  }
  
  
  func makePlatform() {
    makePlatform(nil, lengthRelativeToFrameWidth: nil, relativePositionAbovePrevious: nil);
  }
  
  
  func reset(ball: Ball, menu: MainMenu) {
    for platform in array {
      platform.removeFromParent()
    }
    array.removeAll()
    
    let firstPlatform = Platform(length: gameFrame.width*0.3, position: CGPointMake(ball.position.x, gameFrame.height/7))
    firstPlatform.build()
    firstPlatform.hasScored = true
    firstPlatform.makeSureIsInFrame()
    array.append(firstPlatform)
    ball.position.x = firstPlatform.position.x
    
    makePlatform(
      true,
      lengthRelativeToFrameWidth: random(0.15, to: 0.25),
      relativePositionAbovePrevious: CGPointMake(CGFloat(Int(random(1, to: 3))) / 3.0, 0)
    )
    
    array[1].position.y = menu.highScoreBox.position.y - (menu.highScoreBox.frame.height/2 + 2*menu.marginWidth + array[1].frame.height)
    
    makePlatform(
      true,
      lengthRelativeToFrameWidth: random(0.25, to: 0.35),
      relativePositionAbovePrevious: CGPointMake(random(0, to: 1), random(0.6, to: 0.66))
    )
  }
  
  
  func containPoint(point: CGPoint) -> Bool {
    if array[gameScene.score.amount].containsPoint(point) {return true}
    if array[gameScene.score.amount+1].containsPoint(point) {return true}
    return false
  }
}
