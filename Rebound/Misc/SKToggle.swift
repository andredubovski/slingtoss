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
  let popIn = SKAction.sequence([SKAction.scaleTo(0.85, duration: 0.05)])
  let pressOut = SKAction.sequence([SKAction.scaleTo(0.95, duration: 0.04), SKAction.scaleTo(0.9, duration: 0.03)])
  var turnOnAction = SKAction()
  var turnOffAction = SKAction()
  
  func setStateTo(state: Bool) {
    self.state = state
    
    if self.state {
      runAction(SKAction.group([pressOut, turnOnAction]))
      fillColor = darkColor
    } else {
      runAction(SKAction.group([releaseOut, turnOffAction]))
      fillColor = lightColor
    }
  }
  
  func toggleState() {setStateTo(!state)}
  
  override func doWhenTouchesBegan(location: CGPoint) {
    if containsPoint(location){
      fillColor = darkColor
      removeAllActions()
      runAction(popIn)
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
          runAction(popIn)
          isPressed = true
        }
      } else if isPressed {
        state ? darkenColor() : resetColor()
        removeAllActions()
        runAction(state ? pressOut : releaseOut)
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
