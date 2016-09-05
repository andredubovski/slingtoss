//
//  Score.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/8/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Score {
  
  var amount = Int(0)
  var box = SKSpriteNode(color: currentTheme.uiColor, size: CGSizeZero)
  var label = SKLabelNode()
  
  init() {
    
  }
  
  func build(scene: SKScene) {
    label.text = String(amount)
    label.fontColor = currentTheme.tintColor
    label.position = CGPointMake(0, -label.frame.height/2)
    box.addChild(label)
    box.color = currentTheme.uiColor
    box.size = CGSizeMake(label.frame.width+10, label.frame.height+10)
    box.position = CGPointMake(box.frame.width/2, scene.frame.height-box.frame.height/2)
    box.zPosition = 7
    scene.addChild(box)
  }
  
  func build() {
    build(gameScene)
  }
  
  private func draw() {
    label.text = String(amount)
    box.size = CGSizeMake(label.frame.width+10, box.frame.height)
    box.position = CGPointMake(box.frame.width/2, box.position.y)
  }
  
  func increment() {
    amount += 1
    draw()
  }
  
  func decrement() {
    amount += 1
    draw()
  }
  
  func set(to: Int) {
    amount = to
    draw()
  }
  
  func reset() {

    let defaults = NSUserDefaults()
    if amount > defaults.integerForKey("high score") {
      defaults.setInteger(amount, forKey: "high score")
    }
    
    amount = 0
    draw()
    
    box.removeAllActions()
    box.alpha = 0
  }
  
  func appear() {
    box.removeAllActions()
    box.runAction(fadeIn)
  }
}