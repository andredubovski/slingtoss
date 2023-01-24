//
//  MainMenu.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit
import iRate

class MainMenu {
  
  var isActive = Bool(false)
  var wasPressed = Bool(false)
  
  var buttonToMarginRatio = CGFloat(0.2)
  var buttonWidth = CGFloat()
  var marginWidth = CGFloat()
  
  var elements = [SKNode]()
  var title = SKLabelNode(text: "SlingToss")
  var button1 = SKButton()
  var button2 = SKButton()
  var button3 = SKButton()
  var highScoreBox = SKShapeNode()
  var highScoreLabel = SKLabelNode()
  
  init() {
    
  }
  
  func build(_ scene: SKScene = gameScene) {
    print("building main menu in scene \(scene)")
    buttonWidth = gameFrame.width / (3 + 4*buttonToMarginRatio)
    marginWidth = buttonWidth*buttonToMarginRatio
    
    title.position = CGPoint(x: gameFrame.midX, y: gameFrame.height*0.86)
    title.fontColor = currentTheme.titleColor
    title.fontSize = 78.0 * gameFrame.width/320
    title.run(SKAction.scale(to: (gameFrame.width-2*marginWidth)/title.frame.width, duration: 0))
    elements.append(title)
    scene.addChild(title)
    
    button1 = SKButton(setSize: CGSize(width: buttonWidth, height: buttonWidth), setGlyph: "settings")
    button1.position = CGPoint(
      x: gameFrame.midX - (buttonWidth + marginWidth),
      y: title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button1.buttonAction = SKAction.run({scene.view?.presentScene(settingsScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))})
    button1.display(scene)
    elements.append(button1)
    
    button2 = SKButton(setSize: CGSize(width: buttonWidth, height: buttonWidth), setGlyph: "review")
    button2.position = CGPoint(
      x: gameFrame.midX,
      y: title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button2.buttonAction = SKAction.run({iRate.sharedInstance().openRatingsPageInAppStore()})
    button2.display(scene)
    elements.append(button2)
    
    button3 = SKButton(setSize: CGSize(width: buttonWidth, height: buttonWidth), setGlyph: "info")
    button3.position = CGPoint(
      x: gameFrame.midX + (buttonWidth + marginWidth),
      y: title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button3.display(scene)
    button3.buttonAction =
      SKAction.run({
        menuScene.tutorial.texture = SKTexture(image: #imageLiteral(resourceName: "tutorial"))
        menuScene.tutorial.isSequence = true;
        menuScene.tutorial.show()
      })
    elements.append(button3)
    
    highScoreBox = SKShapeNode(rect: CGRect(
      x: -(gameFrame.width - 2*marginWidth)/2, y: -(2*marginWidth)/2,
      width: gameFrame.width - 2*marginWidth, height: 2*marginWidth
    ))
    highScoreBox.fillColor = currentTheme.uiColor
    highScoreBox.lineWidth = 0
    highScoreBox.position = CGPoint(x: gameFrame.midX, y: button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
    scene.addChild(highScoreBox)
    elements.append(highScoreBox)
    
    let defaults = UserDefaults()
    highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(defaults.integer(forKey: "high score"))")
    highScoreLabel.fontColor = currentTheme.tintColor
    highScoreLabel.fontName = configStringForKey("Score font")
    highScoreLabel.fontSize = 32 * gameFrame.width/320
    highScoreLabel.run(SKAction.scale(to: (highScoreBox.frame.height*0.8)/highScoreLabel.frame.height, duration: 0))
    highScoreBox.addChild(highScoreLabel)
    highScoreLabel.position.y = -highScoreLabel.frame.height/2
    
  }
  
  
  func doWhenTouchesBegan(_ location: CGPoint) {
    if isActive {
      button1.doWhenTouchesBegan(location)
      button2.doWhenTouchesBegan(location)
      button3.doWhenTouchesBegan(location)
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func doWhenTouchesMoved(_ location: CGPoint) {
    if isActive {
      button1.doWhenTouchesMoved(location)
      button2.doWhenTouchesMoved(location)
      button3.doWhenTouchesMoved(location)
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func doWhenTouchesEnded(_ location: CGPoint, shot: Bool = false) {
    if isActive {
      button1.doWhenTouchesEnded(location)
      button2.doWhenTouchesEnded(location)
      button3.doWhenTouchesEnded(location)
      
      if shot {disappear()}
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func appear() {
    highScoreLabel.text = "HIGH SCORE: \(defaults.integer(forKey: "high score"))"
    for element in elements {
      element.removeAllActions()
      element.run(fadeIn)
    }
    isActive = true
  }
  
  
  func disappear() {
    for element in elements {
      element.removeAllActions()
      element.run(fadeOut)
    }
    isActive = false
  }
  
  
  func show() {
    highScoreLabel.text = "HIGH SCORE: \(defaults.integer(forKey: "high score"))"
    for element in elements {
      element.removeAllActions()
      element.alpha = 1
    }
    isActive = true
  }
  
  
  
  func hide() {
    for element in elements {
      element.removeAllActions()
      element.alpha = 0
    }
    isActive = false
  }
  
}
