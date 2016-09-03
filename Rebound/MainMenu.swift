//
//  MainMenu.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/28/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class MainMenu {
  
  var isActive = Bool(false)
  var wasPressed = Bool(false)
  
  var buttonToMarginRatio = CGFloat(0.2)
  var buttonWidth = CGFloat()
  var marginWidth = CGFloat()
  
  var elements = [SKNode]()
  var title = SKLabelNode(text: "Rebound")
  var button1 = SKButton()
  var button2 = SKButton()
  var button3 = SKButton()
  var highScoreBox = SKShapeNode()
  var highScoreLabel = SKLabelNode()
  
  init() {
    
  }
  
  func build(scene: SKScene = gameScene) {
    buttonWidth = gameFrame.width / (3 + 4*buttonToMarginRatio)
    marginWidth = buttonWidth*buttonToMarginRatio
    
    title.position = CGPointMake(gameFrame.midX, gameFrame.height*0.86)
    title.fontColor = currentTheme.titleColor
    title.fontSize = 78.0 * gameFrame.width/320
    title.runAction(SKAction.scaleTo((gameFrame.width-2*marginWidth)/title.frame.width, duration: 0))
    elements.append(title)
    scene.addChild(title)
    
    button1 = SKButton(setSize: CGSizeMake(buttonWidth, buttonWidth), setColor: currentTheme.uiColor, setGlyph: "settings", setGlyphColor: currentTheme.tintColor)
    button1.position = CGPointMake(
      gameFrame.midX - (buttonWidth + marginWidth),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button1.buttonAction = SKAction.runBlock({scene.view?.presentScene(settingsScene, transition: SKTransition.doorsOpenHorizontalWithDuration(0.5))})
    button1.display()
    elements.append(button1)
    
    button2 = SKButton(setSize: CGSizeMake(buttonWidth, buttonWidth), setColor: currentTheme.uiColor, setGlyph: "review", setGlyphColor: currentTheme.tintColor)
    button2.position = CGPointMake(
      gameFrame.midX,
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button2.buttonAction = SKAction.runBlock({iRate.sharedInstance().openRatingsPageInAppStore()})
    button2.display()
    elements.append(button2)
    
    button3 = SKButton(setSize: CGSizeMake(buttonWidth, buttonWidth), setColor: currentTheme.uiColor, setGlyph: "info", setGlyphColor: currentTheme.tintColor)
    button3.position = CGPointMake(
      gameFrame.midX + (buttonWidth + marginWidth),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    button3.display()
    elements.append(button3)
    
    highScoreBox = SKShapeNode(rect: CGRectMake(
      -(gameFrame.width - 2*marginWidth)/2, -(2*marginWidth)/2,
      gameFrame.width - 2*marginWidth, 2*marginWidth
    ))
    highScoreBox.fillColor = currentTheme.uiColor
    highScoreBox.lineWidth = 0
    highScoreBox.position = CGPointMake(gameFrame.midX, button2.position.y - (buttonWidth/2 + marginWidth + highScoreBox.frame.height/2))
    scene.addChild(highScoreBox)
    elements.append(highScoreBox)
    
    let defaults = NSUserDefaults()
    highScoreLabel = SKLabelNode(text: "HIGH SCORE: \(defaults.integerForKey("high score"))")
    highScoreLabel.fontColor = currentTheme.tintColor
    highScoreLabel.position.y = -highScoreLabel.frame.height/2
    highScoreLabel.fontSize = 32 * gameFrame.width/320
    highScoreLabel.runAction(SKAction.scaleTo((highScoreBox.frame.height*0.8)/highScoreLabel.frame.height, duration: 0))
    highScoreBox.addChild(highScoreLabel)
    
  }
  
  
  func doWhenTouchesBegan(location: CGPoint) {
    if isActive {
      button1.doWhenTouchesBegan(location)
      button2.doWhenTouchesBegan(location)
      button3.doWhenTouchesBegan(location)
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func doWhenTouchesMoved(location: CGPoint) {
    if isActive {
      button1.doWhenTouchesMoved(location)
      button2.doWhenTouchesMoved(location)
      button3.doWhenTouchesMoved(location)
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func doWhenTouchesEnded(location: CGPoint, shot: Bool) {
    if isActive {
      button1.doWhenTouchesEnded(location)
      button2.doWhenTouchesEnded(location)
      button3.doWhenTouchesEnded(location)
      
      if shot {disappear()}
    }
    
    wasPressed = button1.wasPressed || button2.wasPressed || button3.wasPressed
  }
  
  
  func appear() {
    for element in elements {
      element.removeAllActions()
      element.runAction(fadeIn)
    }
    isActive = true
  }
  
  
  func disappear() {
    for element in elements {
      element.removeAllActions()
      element.runAction(fadeOut)
    }
    isActive = false
  }
  
  
  func show() {
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
