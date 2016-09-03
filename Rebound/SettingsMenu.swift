//
//  SettingsMenu.swift
//  Rebound
//
//  Created by Andre Dubovskiy on 9/3/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class SettingsMenu: SKNode {
  
  //sound
  var sfxToggle = SKToggle()
  var musicToggle = SKToggle()
  
  //themes
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
