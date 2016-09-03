//
//  SKToggle.swift
//  Rebound
//
//  Created by Andre Dubovskiy on 9/3/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class SKToggle: SKButton {
  
  var state = Bool(false)
  let popOut = SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.035), SKAction.scaleTo(1.1, duration: 0.035)])
  let releaseIn = SKAction.sequence([SKAction.scaleTo(0.9, duration: 0.05), SKAction.scaleTo(1, duration: 0.035)])
  var turnOnAction = SKAction()
  var turnOffAction = SKAction()
  
  func setStateTo(state: Bool) {
    self.state = state
    
    if self.state {
      runAction(SKAction.group([pressIn, turnOnAction]))
      fillColor = darkColor
    } else {
      runAction(SKAction.group([releaseIn, turnOffAction]))
      fillColor = lightColor
    }
  }
  
  func toggleState() {setStateTo(!state)}
  
  override func doWhenTouchesBegin(location: CGPoint) {
    if containsPoint(location){
      fillColor = darkColor
      removeAllActions()
      runAction(popOut)
      isPressed = true
      wasPressed = true
    } else {
      isPressed = false
      wasPressed = false
    }
  }
  
  override func doWhenTouchesMoved(location: CGPoint) {
    if wasPressed {
      if containsPoint(location){
        if !isPressed {
          fillColor = darkColor
          removeAllActions()
          runAction(popOut)
          isPressed = true
        }
      } else if isPressed {
        state ? darkenColor() : resetColor()
        removeAllActions()
        runAction(state ? pressIn : releaseIn)
        isPressed = false
      }
    }
  }
  
  override func doWhenTouchesEnded(location: CGPoint) {
    if wasPressed {      
      if containsPoint(location){
        removeAllActions()
        toggleState()
      }
    }
    wasPressed = false
    isPressed = false
  }
  
  
  
}
