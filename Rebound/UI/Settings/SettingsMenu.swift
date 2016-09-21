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
  
  func build(_ scene: SKScene) {
    buttonWidth = gameFrame.width / (2 + 3*buttonToMarginRatio)
    marginWidth = buttonWidth*buttonToMarginRatio
    
    
    title.position = CGPoint(x: gameFrame.midX, y: gameFrame.height*0.86)
    title.fontColor = currentTheme.titleColor
    title.fontSize = 78.0 * gameFrame.width/320
    title.run(SKAction.scale(to: (gameFrame.width-2*marginWidth)/title.frame.width, duration: 0))
    scene.addChild(title)
    
    
    sfxToggle = SKToggle(setSize: CGSize(width: buttonWidth, height: buttonWidth), setGlyph: "SFX")
    sfxToggle.position = CGPoint(
      x: gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      y: title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    sfxToggle.turnOnAction = SKAction.run({defaults.set(true, forKey: "SFX")})
    sfxToggle.turnOffAction = SKAction.run({defaults.set(false, forKey: "SFX")})
    sfxToggle.display(scene)
    sfxToggle.setStateTo(defaults.bool(forKey: "SFX"))
    
    musicToggle = SKToggle(setSize: CGSize(width: buttonWidth, height: buttonWidth), setGlyph: "Music")
    musicToggle.position = CGPoint(
      x: gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      y: title.position.y - (title.frame.height/2 + buttonWidth/2)
    )
    musicToggle.turnOnAction = SKAction.run({
      defaults.set(true, forKey: "Music")
      gameScene.backgroundMusicPlayer.volume = 0.24
      gameScene.backgroundMusicPlayer.play()
    })
    musicToggle.turnOffAction = SKAction.run({
      defaults.set(false, forKey: "Music")
      gameScene.backgroundMusicPlayer.volume = 0.0
      gameScene.backgroundMusicPlayer.pause()
    })
    musicToggle.display(scene)
    musicToggle.setStateTo(defaults.bool(forKey: "Music"))
    
    
    removeAdsToggle = SKToggle(setSize: CGSize(width: buttonWidth, height: buttonWidth/1.5), setGlyph: "removeAds")
    removeAdsToggle.position = CGPoint(
      x: gameFrame.midX - (buttonWidth/2 + marginWidth/2),
      y: musicToggle.position.y - (buttonWidth/2 + removeAdsToggle.size.height/2 + marginWidth)
    )
    removeAdsToggle.turnOnAction = SKAction.run({defaults.set(false, forKey: "Ads")})
    removeAdsToggle.turnOffAction = SKAction.run({defaults.set(true, forKey: "Ads")})
    removeAdsToggle.display(scene)
    removeAdsToggle.setStateTo(!defaults.bool(forKey: "Ads"))
    
    refreshIAPButton = SKButton(setSize: CGSize(width: buttonWidth, height: buttonWidth/1.5), setGlyph: "refreshIAP")
    refreshIAPButton.position = CGPoint(
      x: gameFrame.midX + (buttonWidth/2 + marginWidth/2),
      y: musicToggle.position.y - (buttonWidth/2 + refreshIAPButton.size.height/2 + marginWidth)
    )
    refreshIAPButton.display(scene)
    
    
    homeButton = SKButton(setSize: CGSize(width: buttonWidth/1.5, height: buttonWidth/1.5), setGlyph: "home")
    homeButton.position = CGPoint(
      x: marginWidth+homeButton.size.width/2,
      y: removeAdsToggle.position.y - (removeAdsToggle.frame.height/2 + homeButton.size.height/2 + marginWidth)
    )
    homeButton.buttonAction = SKAction.run({scene.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.5))})
    homeButton.display(scene)
    
    creditsButton = SKButton(setSize: CGSize(width: gameFrame.width - (3*marginWidth + homeButton.frame.width), height: homeButton.frame.height), setGlyph: "credits")
    creditsButton.position = CGPoint(
      x: homeButton.position.x + (homeButton.frame.width/2 + creditsButton.size.width/2 + marginWidth),
      y: homeButton.position.y
    )
    creditsButton.buttonAction = SKAction()
    creditsButton.display(scene)

  }
  
  func doWhenTouchesBegan(_ location: CGPoint) {
    sfxToggle.doWhenTouchesBegan(location)
    musicToggle.doWhenTouchesBegan(location)
    removeAdsToggle.doWhenTouchesBegan(location)
    refreshIAPButton.doWhenTouchesBegan(location)
    creditsButton.doWhenTouchesBegan(location)
    homeButton.doWhenTouchesBegan(location)
  }
  
  func doWhenTouchesMoved(_ location: CGPoint) {
    sfxToggle.doWhenTouchesMoved(location)
    musicToggle.doWhenTouchesMoved(location)
    removeAdsToggle.doWhenTouchesMoved(location)
    refreshIAPButton.doWhenTouchesMoved(location)
    creditsButton.doWhenTouchesMoved(location)
    homeButton.doWhenTouchesMoved(location)
  }
  
  func doWhenTouchesEnded(_ location: CGPoint) {
    sfxToggle.doWhenTouchesEnded(location)
    musicToggle.doWhenTouchesEnded(location)
    removeAdsToggle.doWhenTouchesEnded(location)
    refreshIAPButton.doWhenTouchesEnded(location)
    creditsButton.doWhenTouchesEnded(location)
    homeButton.doWhenTouchesEnded(location)
  }
  
}
