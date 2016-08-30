//
//  DeathMenu.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class DeathMenu: MainMenu {
  
  var scoreAmount = Int()
  var scoreBox = SKShapeNode()
  var scoreLabel = SKLabelNode()
  
  override func build(scene: SKScene = gameScene) {
    
    super.build()
    
    title.text = "Game over!"
    title.fontSize = 70.0 * gameFrame.width/320
    title.yScale = (gameFrame.width-2*marginWidth)/title.frame.width
    title.xScale = (gameFrame.width-2*marginWidth)/title.frame.width
    
    button1.makeGlyph("home")
    button1.buttonAction = SKAction.runBlock({self.disappear(); gameScene.menu.appear()})
    button2.makeGlyph("share")
    button2.buttonAction = SKAction.runBlock({

      let vc = gameScene.view?.window?.rootViewController
      
      let shareText = "Just got \(self.scoreAmount) point\(self.scoreAmount == 1 ? "" : "s") playing Rebound. Check it out! www.oakl.in/rebound"
      
      let shareImage = gameScene.getScreenShot()
      
      let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: nil)
      
      vc?.presentViewController(activityVC, animated: true, completion: nil)
      
    })
    button3.makeGlyph("gameCenter")
    
    
    
    scoreBox.path = CGPathCreateWithRect(CGRectMake(
      -(gameFrame.width - 3*marginWidth)/4, -(2*marginWidth)/2,
      (gameFrame.width - 3*marginWidth)/2, 2*marginWidth
      ), nil)
    scoreBox.fillColor = currentTheme.uiColor
    scoreBox.lineWidth = 0
    scoreBox.position = CGPointMake(gameFrame.midX - (marginWidth/2 + scoreBox.frame.width/2), button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
    scene.addChild(scoreBox)
    elements.append(scoreBox)
    
    scoreLabel.text = "SCORE: \(scoreAmount)"
    scoreLabel.fontColor = currentTheme.tintColor
    scoreLabel.position.y = -scoreLabel.frame.height*0.4
    scoreLabel.fontSize = highScoreLabel.fontSize
    scoreLabel.removeAllActions()
    scoreLabel.xScale = 1
    scoreLabel.yScale = 1
    scoreLabel.xScale = (scoreBox.frame.width*0.85)/scoreLabel.frame.width
    scoreLabel.yScale = scoreLabel.xScale
    scoreBox.addChild(scoreLabel)
    
    

    highScoreBox.path = CGPathCreateWithRect(CGRectMake(
      -(gameFrame.width - 3*marginWidth)/4, -(2*marginWidth)/2,
      (gameFrame.width - 3*marginWidth)/2, 2*marginWidth
      ), nil)
    highScoreBox.position = CGPointMake(gameFrame.midX + (marginWidth/2 + highScoreBox.frame.width/2), button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
    
    let defaults = NSUserDefaults()
    highScoreLabel.text = "HIGH: \(defaults.integerForKey("high score"))"
    highScoreLabel.position.y = -highScoreLabel.frame.height*0.4
    highScoreLabel.removeAllActions()
    highScoreLabel.xScale = 1
    highScoreLabel.yScale = 1
    highScoreLabel.xScale = scoreLabel.xScale
    highScoreLabel.yScale = scoreLabel.yScale
    
  }
  
  func appear(scoreAmount: Int) {
    self.scoreAmount = scoreAmount
    
    let defaults = NSUserDefaults()
    if scoreAmount > defaults.integerForKey("high score") {
      defaults.setInteger(scoreAmount, forKey: "high score")
      highScoreLabel.text = "HIGH: \(defaults.integerForKey("high score"))"
    }
    
    scoreLabel.text = "SCORE: \(scoreAmount)"
    scoreLabel.removeAllActions()
    highScoreLabel.xScale = 1
    highScoreLabel.yScale = 1
    scoreLabel.xScale = 1
    scoreLabel.yScale = 1
    scoreLabel.xScale = (scoreBox.frame.width*0.85)/scoreLabel.frame.width
    scoreLabel.yScale = scoreLabel.xScale
    highScoreLabel.removeAllActions()
    highScoreLabel.xScale = scoreLabel.xScale
    highScoreLabel.yScale = scoreLabel.yScale
    
    appear()
  }
  
}