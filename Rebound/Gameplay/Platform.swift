//
//  Platform.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

class Platform: Terrain {
  
  //various dimensions of platform
  var length = CGFloat()
  var edgeHeight = CGFloat()
  
  init(length: CGFloat) {
    super.init()
    
    //calculate platform dimensions based on screen size
    self.length = length
    edgeHeight = gameFrame.width * configValueForKey("Relative platform edge height")
  }
  
  convenience init(length: CGFloat, position: CGPoint) {
    self.init(length: length)
    self.position = position
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func build() {
    
    //create path that has platform shape based on dimensions
    let mutablePath = CGMutablePath()
    mutablePath.move(to: CGPoint(x: 0, y: 0))
    mutablePath.addLine(to: CGPoint(x: -length/2, y: 0))
    mutablePath.addLine(to: CGPoint(x: length/2, y: 0))
    mutablePath.addLine(to: CGPoint(x: length/2 + edgeHeight/sqrt(2), y: edgeHeight/sqrt(2)))
    mutablePath.addLine(to: CGPoint(x: length/2 + (edgeHeight-thickness)/sqrt(2), y: (edgeHeight+thickness)/sqrt(2)))
    mutablePath.addLine(to: CGPoint(x: length/2 - thickness*tan(radians(22.5)), y: thickness))
    mutablePath.addLine(to: CGPoint(x: -(length/2 - thickness*tan(radians(22.5))), y: thickness))
    mutablePath.addLine(to: CGPoint(x: -length/2 - (edgeHeight-thickness)/sqrt(2), y: (edgeHeight+thickness)/sqrt(2)))
    mutablePath.addLine(to: CGPoint(x: -(length/2 + edgeHeight/sqrt(2)), y: edgeHeight/sqrt(2)))
    mutablePath.closeSubpath()
    path = mutablePath
    
    super.build()
    let randomLength = random(configValueForKey("Min relative platform length"), to: configValueForKey("Max relative platform length")) * gameFrame.width
    if isPermeable {fillColor = currentTheme.permeablePlatformColor(randomLength); name = "permeable platform"}
    else {fillColor = currentTheme.impermeablePlatformColor(randomLength); name = "impermeable platform"}
    
  }
  
}
