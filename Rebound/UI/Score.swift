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
  var box = SKSpriteNode(color: currentTheme.uiColor, size: CGSize.zero)
  var label = SKLabelNode()
  
  init() {
    
  }
  
  func build(_ scene: SKScene) {
    label.text = String(amount)
    label.fontColor = currentTheme.tintColor
    label.position = CGPoint(x: 0, y: -label.frame.height/2)
    box.addChild(label)
    box.color = currentTheme.uiColor
    box.size = CGSize(width: label.frame.width+10, height: label.frame.height+10)
    box.position = CGPoint(x: box.frame.width/2, y: scene.frame.height-box.frame.height/2)
    box.zPosition = 7
    scene.addChild(box)
  }
  
  func build() {
    build(gameScene)
  }
  
  fileprivate func draw() {
    label.text = String(amount)
    box.size = CGSize(width: label.frame.width+10, height: box.frame.height)
    box.position = CGPoint(x: box.frame.width/2, y: box.position.y)
  }
  
  func increment() {
    amount += 1
    draw()
  }
  
  func decrement() {
    amount += 1
    draw()
  }
  
  func set(_ to: Int) {
    amount = to
    draw()
  }
  
  func reset() {

    let defaults = UserDefaults()
    if amount > defaults.integer(forKey: "high score") {
      defaults.set(amount, forKey: "high score")
    }
    
    amount = 0
    draw()
    
    box.removeAllActions()
    box.alpha = 0
  }
  
  func appear() {
    box.removeAllActions()
    box.run(fadeIn)
  }
}
