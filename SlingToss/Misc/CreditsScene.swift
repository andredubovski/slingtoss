//
//  CreditsScene.swift
//
//
//  Created by Andre Dubovskiy on 11/14/16.
//
//

import SpriteKit

class CreditsScene: SKScene {
  var isVirgin = Bool(true)
  
  override func didMove(to view: SKView) {
    gameScene.ataBanner.isHidden = true
    if isVirgin {
      let bg = Background(imageNamed: "background1")
      bg.build(self)
      
      let creditsImage = SKSpriteNode(imageNamed: "Credits")
      creditsImage.position = CGPoint(x: frame.midX, y: frame.midY)
      creditsImage.yScale = frame.height/creditsImage.frame.height
      creditsImage.xScale = creditsImage.yScale
      addChild(creditsImage)
      
      isVirgin = false
    }
    
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.5))
  }
  
}
