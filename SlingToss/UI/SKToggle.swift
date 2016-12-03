//
//  SKToggle.swift
//  SlingToss
//
//  Created by Andre Dubovskiy on 9/3/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit

class SKToggle: SKButton {
  
  var state = Bool(false)
  let popIn = SKAction.sequence([SKAction.scale(to: 0.85, duration: 0.05)])
  let pressOut = SKAction.sequence([SKAction.scale(to: 0.95, duration: 0.04), SKAction.scale(to: 0.9, duration: 0.03)])
  var turnOnAction = SKAction()
  var turnOffAction = SKAction()
  
  func setStateTo(_ state: Bool, withAction: Bool = true) {
    removeAllActions()
    self.state = state
    
    if withAction {
      if self.state {
        run(SKAction.group([pressOut, turnOnAction]))
        fillColor = darkColor
      } else {
        run(SKAction.group([releaseOut, turnOffAction]))
        fillColor = lightColor
      }
    } else {
      if self.state {
        run(SKAction.group([pressOut]))
        fillColor = darkColor
      } else {
        run(SKAction.group([releaseOut]))
        fillColor = lightColor
      }
    }
    
    if defaults.bool(forKey: "SFX") {
      clickPlayer.play()
    }
  }
  
  func toggleState() {setStateTo(!state)}
  
  override func doWhenTouchesBegan(_ location: CGPoint) {
    if contains(location){
      fillColor = darkColor
      removeAllActions()
      run(popIn)
      isPressed = true
      wasPressed = true
    } else {
      isPressed = false
      wasPressed = false
    }
  }
  
  override func doWhenTouchesMoved(_ location: CGPoint) {
    if wasPressed {
      if contains(location){
        if !isPressed {
          fillColor = darkColor
          removeAllActions()
          run(popIn)
          isPressed = true
        }
      } else if isPressed {
        state ? darkenColor() : resetColor()
        removeAllActions()
        run(state ? pressOut : releaseOut)
        isPressed = false
      }
    }
  }
  
  override func doWhenTouchesEnded(_ location: CGPoint) {
    if wasPressed {
      if contains(location){
        toggleState()
      }
    }
    wasPressed = false
    isPressed = false
  }
  
  
  
}
