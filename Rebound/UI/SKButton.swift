//
//  Button.swift
//  Helix
//
//  Created by Andre Oaklin on 6/25/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class SKButton: SKShapeNode {
  
  var size = CGSize(width: 120, height: 120)
  var lightColor = SKColor()
  var darkColor = SKColor()
  var glyph = SKSpriteNode()
  var glyphColor: SKColor? = nil
  
  var wasPressed = Bool(false)
  var isPressed = Bool(false)
  let pressIn = SKAction.scale(to: 0.95, duration: 0.03)
  let releaseOut = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.05), SKAction.scale(to: 1, duration: 0.035)])
  
  var buttonAction = SKAction()
  
  override init() {
    super.init()
  }
  
  convenience init(setSize: CGSize, setColor: SKColor = currentTheme.uiColor, setGlyph: String, setGlyphColor: SKColor? = currentTheme.tintColor) {
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
  
  func display(_ scene: SKScene) {
    fillColor = lightColor
    lineWidth = 0
    path = CGPath(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height), transform: nil)
    position = position
    zPosition = 5
    glyph.run(SKAction.scale(to: (size.width*0.8)/glyph.frame.width, duration: 0))
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
  
  func makeGlyph(_ imageNamed: String) {
    var glyphImage = UIImage(named: imageNamed)
    if let color = glyphColor {
      tintImage(&glyphImage!, color: color)
    }
    glyph.texture = SKTexture(image: glyphImage!)
  }
  
  func doWhenTouchesBegan(_ location: CGPoint) {
    if contains(location){
      fillColor = darkColor
      run(pressIn)
      isPressed = true
      wasPressed = true
    } else {
      isPressed = false
      wasPressed = false
    }
  }
  
  func doWhenTouchesMoved(_ location: CGPoint) {
    if wasPressed {
      if contains(location){
        fillColor = darkColor
        run(pressIn)
        isPressed = true
      } else if isPressed {resetColor(); run(releaseOut); isPressed = false}
    }
  }
  
  func doWhenTouchesEnded(_ location: CGPoint) {
    if wasPressed {
      resetColor()
      run(releaseOut)
      isPressed = false
      
      if contains(location){
        run(buttonAction)
      }
    }
    wasPressed = false
    isPressed = false
  }
  
}
