//
//  Tutoial.swift
//  SlingToss
//
//  Created by Andre Dubovskiy on 11/24/16.
//  Copyright © 2016 witehat. All rights reserved.
//

import SpriteKit

class Tutorial: SKSpriteNode {
  
  var isShowing = false
  var isSequence = false
  
  let appear = SKAction.fadeAlpha(to: 1, duration: 0.3)
  let pressIn = SKAction.scale(to: 0.95, duration: 0.04)
  let releaseOut = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1)])
  let fade = SKAction.fadeAlpha(to: 0, duration: 0.1)
  var isBeingTouched = false
  
  func build(scene: SKScene = gameScene) {
    size = CGSize(width: 259, height: 318)
    position = CGPoint(x: gameFrame.midX, y: gameFrame.midY)
    zPosition = 100
    alpha = 0
    scene.addChild(self)
  }
  
  
  func show() {
    run(appear)
    isShowing = true
  }
  
  func doWhenTouchesBegan() {
    run(pressIn)
    isBeingTouched = true
  }
  
  func doWhenTouchesEnded() {
    if isBeingTouched {
      if !isSequence {
        run(SKAction.sequence([
          SKAction.group([releaseOut, fade])
          ]))
        isShowing = false
      }
      else {
        run(SKAction.sequence([
          SKAction.group([releaseOut, fade]),
          SKAction.run({
            self.texture = SKTexture(image: #imageLiteral(resourceName: "tutorial_impermeable"))
            self.show()
            })
          ]))
        self.isSequence = false
      }
    }
  isBeingTouched = false
  }
}
