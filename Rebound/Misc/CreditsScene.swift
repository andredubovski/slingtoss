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
    if isVirgin {
      let label1 = SKLabelNode(text: "Credits")
      let label2 = SKLabelNode(text: "Andre Dubovskiy")
      let label3 = SKLabelNode(text: "I did everything.")
      
      addChild(label1)
      addChild(label2)
      addChild(label3)
      
      label1.fontName = "AvenirNext-Bold"
      label3.fontSize = 20
      
      label1.position = CGPoint(x: frame.midX, y: 0.8*frame.height)
      label2.position = CGPoint(x: frame.midX, y: 0.6*frame.height)
      label3.position = CGPoint(x: frame.midX, y: frame.midY)
      
      isVirgin = false
    }
    
  }
  
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.5))
  }
  
}
