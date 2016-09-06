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
  
  override func didMoveToView(view: SKView) {
    print("moved to settings")
    if isVirgin {
      menu.build(self)
      currentTheme.build(self)
      isVirgin = false
    }
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      menu.doWhenTouchesBegan(location)
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      menu.doWhenTouchesMoved(location)
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      menu.doWhenTouchesEnded(location)
    }
  }
  
}
