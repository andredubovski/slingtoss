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
    
    
    sfxToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth), setGlyph: "SFX")
    sfxToggle.position = CGPointMake(
      gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    sfxToggle.turnOnAction = SKAction.runBlock({defaults.setBool(true, forKey: "SFX")})
    sfxToggle.turnOffAction = SKAction.runBlock({defaults.setBool(false, forKey: "SFX")})
    sfxToggle.display(scene)
    sfxToggle.setStateTo(defaults.boolForKey("SFX"))
    
    musicToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth), setGlyph: "Music")
    musicToggle.position = CGPointMake(
      gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    musicToggle.turnOnAction = SKAction.runBlock({defaults.setBool(true, forKey: "Music"); gameScene.beginBgMusic()})
    musicToggle.turnOffAction = SKAction.runBlock({defaults.setBool(false, forKey: "Music"); gameScene.backgroundMusicPlayer.stop()})
    musicToggle.display(scene)
    musicToggle.setStateTo(defaults.boolForKey("Music"))
    
    
    removeAdsToggle = SKToggle(setSize: CGSizeMake(buttonWidth, buttonWidth/1.5), setGlyph: "removeAds")
    removeAdsToggle.position = CGPointMake(
      gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      musicToggle.position.y - (buttonWidth/2 + removeAdsToggle.size.height/2 + marginWidth)
    )
    removeAdsToggle.turnOnAction = SKAction.runBlock({defaults.setBool(false, forKey: "Ads")})
    removeAdsToggle.turnOffAction = SKAction.runBlock({defaults.setBool(true, forKey: "Ads")})
    removeAdsToggle.display(scene)
    removeAdsToggle.setStateTo(!defaults.boolForKey("Ads"))
    
    refreshIAPButton = SKButton(setSize: CGSizeMake(buttonWidth, buttonWidth/1.5), setGlyph: "refreshIAP")
    refreshIAPButton.position = CGPointMake(
      gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      musicToggle.position.y - (buttonWidth/2 + refreshIAPButton.size.height/2 + marginWidth)
    )
    refreshIAPButton.display(scene)
    
    
    homeButton = SKButton(setSize: CGSizeMake(buttonWidth/1.5, buttonWidth/1.5), setGlyph: "home")
    homeButton.position = CGPointMake(
      marginWidth+homeButton.size.width/2,
      removeAdsToggle.position.y - (removeAdsToggle.frame.height/2 + homeButton.size.height/2 + marginWidth)
    )
    homeButton.buttonAction = SKAction.runBlock({scene.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.5))})
    homeButton.display(scene)
    
    creditsButton = SKButton(setSize: CGSizeMake(gameFrame.width - (3*marginWidth + homeButton.frame.width), homeButton.frame.height), setGlyph: "credits")
    creditsButton.position = CGPointMake(
      homeButton.position.x + (homeButton.frame.width/2 + creditsButton.size.width/2 + marginWidth),
      homeButton.position.y
    )
    creditsButton.buttonAction = SKAction()
    creditsButton.display(scene)

  }
  
  func doWhenTouchesBegan(location: CGPoint) {
    sfxToggle.doWhenTouchesBegan(location)
    musicToggle.doWhenTouchesBegan(location)
    removeAdsToggle.doWhenTouchesBegan(location)
    refreshIAPButton.doWhenTouchesBegan(location)
    creditsButton.doWhenTouchesBegan(location)
    homeButton.doWhenTouchesBegan(location)
  }
  
  func doWhenTouchesMoved(location: CGPoint) {
    sfxToggle.doWhenTouchesMoved(location)
    musicToggle.doWhenTouchesMoved(location)
    removeAdsToggle.doWhenTouchesMoved(location)
    refreshIAPButton.doWhenTouchesMoved(location)
    creditsButton.doWhenTouchesMoved(location)
    homeButton.doWhenTouchesMoved(location)
  }
  
  func doWhenTouchesEnded(location: CGPoint) {
    sfxToggle.doWhenTouchesEnded(location)
    musicToggle.doWhenTouchesEnded(location)
    removeAdsToggle.doWhenTouchesEnded(location)
    refreshIAPButton.doWhenTouchesEnded(location)
    creditsButton.doWhenTouchesEnded(location)
    homeButton.doWhenTouchesEnded(location)
  }
  
}
