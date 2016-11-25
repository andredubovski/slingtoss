//
//  Score.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/8/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit
import GameKit


class Score {
  
  var amount = Int(0)
  var box = SKSpriteNode(color: currentTheme.uiColor, size: CGSize.zero)
  var label = SKLabelNode()
  
  var gcEnabled = Bool()
  var gcDefaultLeaderBoard = String()
  
  init() {
    
  }
  
  func build(_ scene: SKScene) {
    label.text = String(amount)
    label.fontName = configStringForKey("Score font")
    label.fontColor = currentTheme.tintColor
    label.position = CGPoint(x: 0, y: -label.frame.height/2)
    box.addChild(label)
    box.color = currentTheme.uiColor
    box.size = CGSize(width: label.frame.width+10, height: label.frame.height+10)
    box.position = CGPoint(x: box.frame.width/2, y: scene.frame.height-box.frame.height/2)
    box.zPosition = 7
    scene.addChild(box)
    
    authenticateLocalPlayer()
    
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
  
  func authenticateLocalPlayer() {
    let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
    
    localPlayer.authenticateHandler = {(ViewController, error) -> Void in
      if((ViewController) != nil) {
        // 1 Show login if player is not logged in
        gameScene.view?.window?.rootViewController?.present(ViewController!, animated: true, completion: nil)
      } else if (localPlayer.isAuthenticated) {
        // 2 Player is already euthenticated & logged in, load game center
        self.gcEnabled = true
        
        // Get the default leaderboard ID
        self.gcDefaultLeaderBoard = "grp.SlingToss.HighScores"
        
        
      } else {
        // 3 Game center is not enabled on the users device
        self.gcEnabled = false
        print("Local player could not be authenticated, disabling game center")
        print(error as Any)
      }
      
    }
    
  }
  
  func submit() {
    let leaderboardID = "grp.SlingToss.HighScores"
    let sScore = GKScore(leaderboardIdentifier: leaderboardID)
    sScore.value = Int64(amount)
    
    GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
      if error != nil {
        print(error!.localizedDescription)
      } else {
        print("Score submitted")
        
      }
    })
  }
  
  func appear() {
    box.removeAllActions()
    box.run(fadeIn)
  }
}
