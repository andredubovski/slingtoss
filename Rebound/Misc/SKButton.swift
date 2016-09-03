//
//  Button.swift
//  Helix
//
//  Created by Andre Oaklin on 6/25/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class SKButton: SKShapeNode {
  
  var size = CGSizeMake(120, 120)
  var lightColor = SKColor()
  var darkColor = SKColor()
  var glyph = SKSpriteNode()
  var glyphColor: SKColor? = nil
  
  var wasPressed = Bool(false)
  var isPressed = Bool(false)
  let pressIn = SKAction.scaleTo(0.95, duration: 0.03)
  let releaseOut = SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.05), SKAction.scaleTo(1, duration: 0.035)])
  
  var buttonAction = SKAction()
  
  override init() {
    super.init()
  }
  
  convenience init(setSize: CGSize, setColor: SKColor, setGlyph: String, setGlyphColor: SKColor? = currentTheme.tintColor) {
    self.init()
    size = setSize
    lightColor = setColor
    darkColor = SKColor(red: redValue(lightColor)*0.65, green: greenValue(lightColor)*0.65, blue: blueValue(lightColor)*0.65, alpha: alphaValue(lightColor)*1.3)
    glyphColor = setGlyphColor
    var glyphImage = UIImage(named: setGlyph)
    if let color = setGlyphColor {
      tintImage(&glyphImage!, color: color)
    }
    glyph = SKSpriteNode(texture: SKTexture(image: glyphImage!))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func display(scene: SKScene) {
    fillColor = lightColor
    lineWidth = 0
    path = CGPathCreateWithRect(CGRectMake(-size.width/2, -size.height/2, size.width, size.height), nil)
    position = position
    zPosition = 5
    glyph.runAction(SKAction.scaleTo((size.height*0.8)/glyph.frame.width, duration: 0))
    scene.addChild(self)
    addChild(glyph)
  }
  
  func display() {
    display(gameScene)
  }
  
  func resetColor() {
    fillColor = lightColor
  }
  
  func darkenColor() {
    fillColor = darkColor
  }
  
  func makeGlyph(imageNamed: String) {
    var glyphImage = UIImage(named: imageNamed)
    if let color = glyphColor {
      tintImage(&glyphImage!, color: color)
    }
    glyph.texture = SKTexture(image: glyphImage!)
  }
  
  func doWhenTouchesBegan(location: CGPoint) {
    if containsPoint(location){
      fillColor = darkColor
      runAction(pressIn)
      isPressed = true
      wasPressed = true
    } else {
      isPressed = false
      wasPressed = false
    }
  }
  
  func doWhenTouchesMoved(location: CGPoint) {
    if wasPressed {
      if containsPoint(location){
        fillColor = darkColor
        runAction(pressIn)
        isPressed = true
      } else if isPressed {resetColor(); runAction(releaseOut); isPressed = false}
    }
  }
  
  func doWhenTouchesEnded(location: CGPoint) {
    if wasPressed {
      resetColor()
      runAction(releaseOut)
      isPressed = false
      
      if containsPoint(location){
        runAction(buttonAction)
      }
    }
    wasPressed = false
    isPressed = false
  }
  
}