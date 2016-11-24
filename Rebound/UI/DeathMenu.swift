//
//  DeathMenu.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit
import GameKit
import iRate

class DeathMenu: MainMenu {

  var scoreAmount = Int()
  var scoreBox = SKShapeNode()
  var scoreLabel = SKLabelNode()
  
  override func build(_ scene: SKScene = gameScene) {
    
    super.build()
    
    title.text = "Game over!"
    title.fontSize = 70.0 * gameFrame.width/320
    title.yScale = (gameFrame.width-2*marginWidth)/title.frame.width
    title.xScale = (gameFrame.width-2*marginWidth)/title.frame.width
    
    button1.makeGlyph("home")
    button1.buttonAction = SKAction.run({self.disappear(); gameScene.menu.appear()})
    button2.makeGlyph("share")
    button2.buttonAction = SKAction.run({
      
      let vc = gameScene.view?.window?.rootViewController
      
      let shareText = "Just got \(self.scoreAmount) point\(self.scoreAmount == 1 ? "" : "s") playing SlingToss. Check it out! https://itunes.apple.com/us/app/slingtoss/id1179068876"
      
      let shareImage = gameScene.getScreenShot()
      
      let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: nil)
      
      vc?.present(activityVC, animated: true, completion: nil)
      
    })
    
    button3.makeGlyph("gameCenter")
    button3.buttonAction = SKAction.run({
      
      let gcVC: GKGameCenterViewController = GKGameCenterViewController()
      gcVC.gameCenterDelegate = gameScene.view?.window?.rootViewController as! GameViewController
      gcVC.viewState = GKGameCenterViewControllerState.leaderboards
      gcVC.leaderboardIdentifier = "grp.SlingToss.HighScores"
      gameScene.view?.window?.rootViewController?.present(gcVC, animated: true, completion: nil)
      
    })
    
    
    scoreBox.path = CGPath(rect: CGRect(
      x: -(gameFrame.width - 3*marginWidth)/4, y: -(2*marginWidth)/2,
      width: (gameFrame.width - 3*marginWidth)/2, height: 2*marginWidth
      ), transform: nil)
    scoreBox.fillColor = currentTheme.uiColor
    scoreBox.lineWidth = 0
    scoreBox.position = CGPoint(x: gameFrame.midX - (marginWidth/2 + scoreBox.frame.width/2), y: button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
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
    
    
    
    highScoreBox.path = CGPath(rect: CGRect(
      x: -(gameFrame.width - 3*marginWidth)/4, y: -(2*marginWidth)/2,
      width: (gameFrame.width - 3*marginWidth)/2, height: 2*marginWidth
      ), transform: nil)
    highScoreBox.position = CGPoint(x: gameFrame.midX + (marginWidth/2 + highScoreBox.frame.width/2), y: button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
    
    let defaults = UserDefaults()
    highScoreLabel.text = "HIGH: \(defaults.integer(forKey: "high score"))"
    highScoreLabel.position.y = -highScoreLabel.frame.height*0.4
    highScoreLabel.removeAllActions()
    highScoreLabel.xScale = 1
    highScoreLabel.yScale = 1
    highScoreLabel.xScale = scoreLabel.xScale
    highScoreLabel.yScale = scoreLabel.yScale
    scoreLabel.position.y = highScoreLabel.position.y
    
  }
  
  func appear(score: Score) {
    self.scoreAmount = score.amount
    
    let defaults = UserDefaults()
    
    score.submit()
    if score.amount > defaults.integer(forKey: "high score") {
      defaults.set(score.amount, forKey: "high score")
      highScoreLabel.text = "HIGH: \(defaults.integer(forKey: "high score"))"
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
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    return
  }
  
}

extension SKLabelNode {
  convenience init(text: String, named: Bool) {
    self.init(text: text)
    if named {self.name = text}
  }
}
