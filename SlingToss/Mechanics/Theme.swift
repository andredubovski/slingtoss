//
//  Theme.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/29/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import SpriteKit

class Theme {
  
  var permeablePlatformColor: () -> SKColor
  var impermeablePlatformColor: () -> SKColor
  var movingAcrossPlatformColor: () -> SKColor
  var ringColor: () -> SKColor
  var movingDownPlatformStrokeColor = SKColor()
  var background = Background()
  var titleColor = SKColor()
  var uiColor = SKColor()
  var tintColor = SKColor()
  var slingColor = SKColor()
  var ballColor = SKColor()
  
  init() {
    func blankColor() -> SKColor {
      return SKColor.clear
    }
    
    permeablePlatformColor = blankColor
    impermeablePlatformColor = blankColor
    movingAcrossPlatformColor = blankColor
    ringColor = blankColor
    
  }
  
  init(permeablePlatformColor: @escaping () -> SKColor,
             impermeablePlatformColor: @escaping () -> SKColor,
             movingAcrossPlatformColor: @escaping () -> SKColor,
             ringColor: @escaping () -> SKColor,
             movingDownPlatformStrokeColor: SKColor = SKColor.white,
             backgroundName: String,
             titleColor: SKColor,
             uiColor: SKColor,
             tintColor: SKColor,
             slingColor: SKColor,
             ballColor: SKColor) {
    self.permeablePlatformColor = permeablePlatformColor
    self.impermeablePlatformColor = impermeablePlatformColor
    self.movingAcrossPlatformColor = movingAcrossPlatformColor
    self.ringColor = ringColor
    self.movingDownPlatformStrokeColor = movingDownPlatformStrokeColor
    self.background = Background(imageNamed: backgroundName)
    self.titleColor = titleColor
    self.uiColor = uiColor
    self.tintColor = tintColor
    self.slingColor = slingColor
    self.ballColor = ballColor
  }
  
  func build(_ scene: SKScene) {
    background.build(scene)
  }
  
  func build() {
    build(gameScene)
  }
  
  func scroll(_ interval: CGFloat) {
    background.scroll(interval)
  }
  
}

var themes = [Theme]()
var currentTheme = Theme()

func assembleThemes() {
  
  func permeablePlatformColor1() -> SKColor {
    let length = random(0.15, to: 0.35) * 320
    return SKColor(
      red: (length*(450/320)-60) / 255,
      green: (length*(450/320)+10) / 255,
      blue: 1,
      alpha: 1
    )
  }
  
  func impermeablePlatformColor1() -> SKColor {
    let length = random(0.15, to: 0.35) * 320
    return SKColor(
      red: 1,
      green: (length*(450/320)-50) / 255,
      blue: (length*(450/320)+20) / 255,
      alpha: 1
    )
  }
  
  func movingAcrossPlatformColor1() -> SKColor {
    let randomFactor = random(0, to: 1)
    return SKColor(
      red: 231/255,
      green: (120 + randomFactor*60) / 255,
      blue: (51 + randomFactor*27) / 255,
      alpha: 1
    )
  }
  
  func ringColor1() -> SKColor {
    let radius = random(0.15, to: 0.24) * 320
    return SKColor(
      red: (radius*(450/320)-60) / 255,
      green: 1-(radius*(160/320)+30) / 255,
      blue: (radius*(580/320)) / 255,
      alpha: 1
    )
  }
  
  let theme1 = Theme(
    permeablePlatformColor: permeablePlatformColor1,
    impermeablePlatformColor: impermeablePlatformColor1,
    movingAcrossPlatformColor: movingAcrossPlatformColor1,
    ringColor: ringColor1,
    backgroundName: "background1",
    titleColor: SKColor.red,
    uiColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.6),
    tintColor: SKColor.black,
    slingColor: SKColor.white,
    ballColor: SKColor.red)
  themes.append(theme1)
  
  currentTheme = themes[defaults.integer(forKey: "theme")]
  
}




