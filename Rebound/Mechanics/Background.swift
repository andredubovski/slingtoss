//
//  Background.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Background {
  
  var imageNamed = String()
  var img1 = SKSpriteNode()
  var img2 = SKSpriteNode()
  
  init() {
    
  }
  
  init(imageNamed: String) {
    self.imageNamed = imageNamed
  }
  
  func build(scene: SKScene = gameScene) {
    img1 = SKSpriteNode(imageNamed: imageNamed)
    img2 = SKSpriteNode(imageNamed: imageNamed)
    scene.addChild(img1)
    scene.addChild(img2)
    img1.position = CGPointMake(gameFrame.midX, gameFrame.midY)
    img2.position = CGPointMake(gameFrame.midX, gameFrame.midY - img1.frame.height)
    img1.zPosition = -10
    img2.zPosition = -10
  }
  
  func scroll(interval: CGFloat) {
    img1.position.y -= interval/2
    img2.position.y -= interval/2
    if img2.position.y < -img2.frame.height/2 {
      img2.position.y += img1.frame.height + img2.frame.height
    }
    if img1.position.y < -img1.frame.height/2 {
      img1.position.y += img1.frame.height + img2.frame.height
    }
  }
  
}