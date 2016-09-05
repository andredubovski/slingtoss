//
//  Theme.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/29/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Theme {
  
  var permeablePlatformColor: (CGFloat) -> SKColor
  var impermeablePlatformColor: (CGFloat) -> SKColor
  var ringColor: (CGFloat) -> SKColor
  var movingPlatformStrokeColor = SKColor()
  var background = Background()
  var titleColor = SKColor()
  var uiColor = SKColor()
  var tintColor = SKColor()
  var slingColor = SKColor()
  var ballColor = SKColor()
  
  init() {
    func blankColor(_: CGFloat) -> SKColor {
      return SKColor.clearColor()
    }
    
    permeablePlatformColor = blankColor
    impermeablePlatformColor = blankColor
    ringColor = blankColor
    
  }
  
  init(permeablePlatformColor: (CGFloat) -> SKColor,
             impermeablePlatformColor: (CGFloat) -> SKColor,
             ringColor: (CGFloat) -> SKColor,
             movingPlatformStrokeColor: SKColor = SKColor.whiteColor(),
             backgroundName: String,
             titleColor: SKColor,
             uiColor: SKColor,
             tintColor: SKColor,
             slingColor: SKColor,
             ballColor: SKColor) {
    self.permeablePlatformColor = permeablePlatformColor
    self.impermeablePlatformColor = impermeablePlatformColor
    self.ringColor = ringColor
    self.movingPlatformStrokeColor = movingPlatformStrokeColor
    self.background = Background(imageNamed: backgroundName)
    self.titleColor = titleColor
    self.uiColor = uiColor
    self.tintColor = tintColor
    self.slingColor = slingColor
    self.ballColor = ballColor
  }
  
  func build(scene: SKScene) {
    background.build(scene)
  }
  
  func build() {
    build(gameScene)
  }
  
  func scroll(interval: CGFloat) {
    background.scroll(interval)
  }
  
}

var themes = [Theme]()
var currentTheme = Theme()

func assembleThemes() {
  
  func permeablePlatformColor1(length: CGFloat) -> SKColor {
    return SKColor(
      red: (length*(450/gameFrame.width)-60) / 255,
      green: (length*(450/gameFrame.width)+10) / 255,
      blue: 1,
      alpha: 1
    )
  }
  
  func impermeablePlatformColor1(length: CGFloat) -> SKColor {
    return SKColor(
      red: 1,
      green: (length*(450/gameFrame.width)-50) / 255,
      blue: (length*(450/gameFrame.width)+20) / 255,
      alpha: 1
    )
  }
  
  func ringColor1(radius: CGFloat) -> SKColor {
    return SKColor(
      red: (radius*(450/gameFrame.width)-60) / 255,
      green: 1-(radius*(160/gameFrame.width)+30) / 255,
      blue: (radius*(580/gameFrame.width)) / 255,
      alpha: 1
    )
  }
  
  let theme1 = Theme(
    permeablePlatformColor: permeablePlatformColor1,
    impermeablePlatformColor: impermeablePlatformColor1,
    ringColor: ringColor1,
    backgroundName: "background1",
    titleColor: SKColor.redColor(),
    uiColor: SKColor(red: 1, green: 1, blue: 1, alpha: 0.6),
    tintColor: SKColor.blackColor(),
    slingColor: SKColor.whiteColor(),
    ballColor: SKColor.redColor())
  themes.append(theme1)
  
  
  func permeablePlatformColor2(length: CGFloat) -> SKColor {
    return SKColor.lightGrayColor()
  }
  
  func impermeablePlatformColor2(length: CGFloat) -> SKColor {
    return SKColor.darkGrayColor()
  }
  
  func ringColor2(radius: CGFloat) -> SKColor {
    return SKColor.lightGrayColor()
  }
  
  let theme2 = Theme(
    permeablePlatformColor: permeablePlatformColor2,
    impermeablePlatformColor: impermeablePlatformColor2,
    ringColor: ringColor2,
    movingPlatformStrokeColor: SKColor.blackColor(),
    backgroundName: "background2",
    titleColor:  SKColor.blackColor(),
    uiColor: SKColor(red: 0, green: 0, blue: 0, alpha: 0.6),
    tintColor: SKColor.whiteColor(),
    slingColor: SKColor.darkGrayColor(),
    ballColor: SKColor.blueColor())
  themes.append(theme2)
  
  
  func permeablePlatformColor3(length: CGFloat) -> SKColor {
    return SKColor(
      red: (length*(450/gameFrame.width)+30) / 255,
      green: (length*(450/gameFrame.width)+30) / 255,
      blue: 0.4,
      alpha: 1
    )
  }
  
  func impermeablePlatformColor3(length: CGFloat) -> SKColor {
    return SKColor(
      red: (length*(200/gameFrame.width)+20) / 255,
      green: (length*(500/gameFrame.width)-30) / 255,
      blue: (length*(450/gameFrame.width)+20) / 255,
      alpha: 1
    )
  }
  
  func ringColor3(radius: CGFloat) -> SKColor {
    return SKColor(
      red: 0.8,
      green: 1-(radius*(220/gameFrame.width)+40) / 255,
      blue: 0.5,
      alpha: 1
    )
  }
  
  let theme3 = Theme(
    permeablePlatformColor: permeablePlatformColor3,
    impermeablePlatformColor: impermeablePlatformColor3,
    ringColor: ringColor3,
    movingPlatformStrokeColor: SKColor.blueColor(),
    backgroundName: "background3",
    titleColor: SKColor.orangeColor(),
    uiColor: SKColor(red: 0, green: 0, blue: 1, alpha: 0.6),
    tintColor: SKColor.whiteColor(),
    slingColor: SKColor.blueColor(),
    ballColor: SKColor.whiteColor())
  themes.append(theme3)
  
  let defaults = NSUserDefaults()
  currentTheme = themes[defaults.integerForKey("theme")]
  
}




