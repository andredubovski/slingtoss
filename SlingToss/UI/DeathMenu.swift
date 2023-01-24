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
  var smallHighScoreBox = SKShapeNode()
  var smallHighScoreLabel = SKLabelNode()
  
  override func build(_ scene: SKScene = gameScene) {
    
    super.build()
    
    title.text = "Game over!"
    title.fontSize = 70.0 * gameFrame.width/320
    title.yScale = (gameFrame.width-2*marginWidth)/title.frame.width
    title.xScale = (gameFrame.width-2*marginWidth)/title.frame.width
    
    button1.makeGlyph("home")
    button1.buttonAction = SKAction.run({self.disappear(); scene.view?.presentScene(menuScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))})
    button2.makeGlyph("share")
    button2.buttonAction = SKAction.run({
      
      let shareText = "Just got \(self.scoreAmount) point\(self.scoreAmount == 1 ? "" : "s") playing SlingToss. Check it out! itunes.apple.com/us/app/slingtoss/id1179068876"
      
      let shareImage = gameScene.getScreenShot()
      
      let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [shareText, shareImage], applicationActivities: nil)
      
      gameScene.view?.window?.rootViewController?.present(activityVC, animated: true, completion: nil)
      
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
    scoreLabel.fontName = configStringForKey("Score font")
    scoreLabel.position.y = -scoreLabel.frame.height*0.4
    scoreLabel.fontSize = highScoreLabel.fontSize
    scoreLabel.removeAllActions()
    scoreLabel.xScale = 1
    scoreLabel.yScale = 1
    scoreLabel.xScale = (scoreBox.frame.width*0.85)/scoreLabel.frame.width
    scoreLabel.yScale = scoreLabel.xScale
    scoreBox.addChild(scoreLabel)
    
    
    smallHighScoreBox.path = CGPath(rect: CGRect(
      x: -(gameFrame.width - 3*marginWidth)/4, y: -(2*marginWidth)/2,
      width: (gameFrame.width - 3*marginWidth)/2, height: 2*marginWidth
    ), transform: nil)
    smallHighScoreBox.fillColor = currentTheme.uiColor
    smallHighScoreBox.lineWidth = 0
    smallHighScoreBox.position = CGPoint(x: gameFrame.midX + (marginWidth/2 + smallHighScoreBox.frame.width/2), y: button2.position.y - (buttonWidth/2 + marginWidth + smallHighScoreBox.frame.height/2))
    scene.addChild(smallHighScoreBox)
    elements.append(smallHighScoreBox)
    
    smallHighScoreLabel.text = "HIGH: \(defaults.integer(forKey: "high score"))"
    smallHighScoreLabel.fontColor = currentTheme.tintColor
    smallHighScoreLabel.fontName = configStringForKey("Score font")
    smallHighScoreLabel.position.y = -scoreLabel.frame.height*0.4
    smallHighScoreLabel.fontSize = highScoreLabel.fontSize
    smallHighScoreLabel.removeAllActions()
    smallHighScoreLabel.xScale = 1
    smallHighScoreLabel.yScale = 1
    smallHighScoreLabel.xScale = (smallHighScoreBox.frame.width*0.85)/smallHighScoreLabel.frame.width
    smallHighScoreLabel.yScale = smallHighScoreLabel.xScale
    smallHighScoreBox.addChild(smallHighScoreLabel)
    scoreLabel.position.y = smallHighScoreLabel.position.y
    
  }
  
  func appear(score: Score) {
    self.scoreAmount = score.amount
    
    let defaults = UserDefaults()
    
    score.submit()
    
    appear()
    
    if score.amount > defaults.integer(forKey: "high score") {
      
      defaults.set(score.amount, forKey: "high score")
      highScoreLabel.text = "NEW HIGH: \(defaults.integer(forKey: "high score"))!"
      smallHighScoreLabel.text = "HIGH: \(defaults.integer(forKey: "high score"))"
      
      scoreBox.removeAllActions()
      scoreBox.alpha = 0
      smallHighScoreBox.removeAllActions()
      smallHighScoreBox.alpha = 0
      
    } else {
    
      highScoreBox.removeAllActions()
      highScoreBox.alpha = 0
      
      smallHighScoreLabel.text = "HIGH: \(defaults.integer(forKey: "high score"))"
      scoreLabel.text = "SCORE: \(scoreAmount)"
      scoreLabel.removeAllActions()
      smallHighScoreLabel.xScale = 1
      smallHighScoreLabel.yScale = 1
      scoreLabel.xScale = 1
      scoreLabel.yScale = 1
      scoreLabel.xScale = (scoreBox.frame.width*0.85)/scoreLabel.frame.width
      scoreLabel.yScale = scoreLabel.xScale
      smallHighScoreLabel.removeAllActions()
      smallHighScoreLabel.xScale = scoreLabel.xScale
      smallHighScoreLabel.yScale = scoreLabel.yScale
        
    }
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
