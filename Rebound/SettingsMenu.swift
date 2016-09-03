//
//  SettingsMenu.swift
//  Rebound
//
//  Created by Andre Dubovskiy on 9/3/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class SettingsMenu: SKNode {
  
  var buttonToMarginRatio = CGFloat(0.2)
  var buttonWidth = CGFloat()
  var marginWidth = CGFloat()
  
  var title = SKLabelNode(text: "Settings")
  
  var sfxToggle = SKToggle()
  var musicToggle = SKToggle()
  
  var removeAdsToggle = SKToggle()
  var refreshIAPButton = SKButton()
  
  var homeButton = SKButton()
  var creditsButton = SKButton()
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func build(scene: SKScene) {
    buttonWidth = gameFrame.width / (2 + 3*buttonToMarginRatio)
    marginWidth = buttonWidth*buttonToMarginRatio
    
    
    title.position = CGPointMake(gameFrame.midX, gameFrame.height*0.86)
    title.fontColor = currentTheme.titleColor
    title.fontSize = 78.0 * gameFrame.width/320
    title.runAction(SKAction.scaleTo((gameFrame.width-2*marginWidth)/title.frame.width, duration: 0))
    scene.addChild(title)
    
    
    sfxToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth), setColor: currentTheme.uiColor, setGlyph: "SFX", setGlyphColor: currentTheme.tintColor)
    sfxToggle.position = CGPointMake(
      gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    sfxToggle.display(scene)
    
    
    musicToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth), setColor: currentTheme.uiColor, setGlyph: "Music", setGlyphColor: currentTheme.tintColor)
    musicToggle.position = CGPointMake(
      gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    musicToggle.display(scene)
    
    
    removeAdsToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth/1.5), setColor: currentTheme.uiColor, setGlyph: "Music", setGlyphColor: currentTheme.tintColor)
    removeAdsToggle.position = CGPointMake(
      gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      musicToggle.position.y - (buttonWidth/2 + removeAdsToggle.size.height/2 + marginWidth)
    )
    removeAdsToggle.display(scene)
    
    
    refreshIAPButton = SKButton(setSize: CGSizeMake(buttonWidth, buttonWidth/1.5), setColor: currentTheme.uiColor, setGlyph: "SFX", setGlyphColor: currentTheme.tintColor)
    refreshIAPButton.position = CGPointMake(
      gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      musicToggle.position.y - (buttonWidth/2 + refreshIAPButton.size.height/2 + marginWidth)
    )
    refreshIAPButton.display(scene)
    
    homeButton = SKButton(setSize: CGSizeMake(buttonWidth/1.5, buttonWidth/1.5), setColor: currentTheme.uiColor, setGlyph: "home", setGlyphColor: currentTheme.tintColor)
    homeButton.position = CGPointMake(
      gameFrame.midX,
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    homeButton.buttonAction = SKAction.runBlock({iRate.sharedInstance().openRatingsPageInAppStore()})
    homeButton.display()

  }
  
  func doWhenTouchesBegan(location: CGPoint) {
    sfxToggle.doWhenTouchesBegan(location)
    musicToggle.doWhenTouchesBegan(location)
    removeAdsToggle.doWhenTouchesBegan(location)
    refreshIAPButton.doWhenTouchesBegan(location)
    creditsButton.doWhenTouchesBegan(location)
  }
  
  func doWhenTouchesMoved(location: CGPoint) {
    sfxToggle.doWhenTouchesMoved(location)
    musicToggle.doWhenTouchesMoved(location)
    removeAdsToggle.doWhenTouchesMoved(location)
    refreshIAPButton.doWhenTouchesMoved(location)
    creditsButton.doWhenTouchesMoved(location)
  }
  
  func doWhenTouchesEnded(location: CGPoint) {
    sfxToggle.doWhenTouchesEnded(location)
    musicToggle.doWhenTouchesEnded(location)
    removeAdsToggle.doWhenTouchesEnded(location)
    refreshIAPButton.doWhenTouchesEnded(location)
    creditsButton.doWhenTouchesEnded(location)
  }
  
}
