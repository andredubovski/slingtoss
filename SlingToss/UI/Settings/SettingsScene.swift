//
//  SettingsScene.swift
//  
//
//  Created by Andre Dubovskiy on 9/3/16.
//
//

import SpriteKit

class SettingsScene: SKScene {
  
  var menu = SettingsMenu()
  
  var isVirgin = Bool(true)
  
  override func didMove(to view: SKView) {
    
    gameScene.ataBanner.isHidden = true
    if isVirgin {
      let bg = Background(imageNamed: "background1")
      bg.build(self)
      menu.build(self)
      currentTheme.build(self)
      isVirgin = false
    }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      menu.doWhenTouchesBegan(location)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      menu.doWhenTouchesMoved(location)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      menu.doWhenTouchesEnded(location)
    }
  }
  
}
