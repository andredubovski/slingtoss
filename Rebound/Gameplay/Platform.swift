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
  var doesMoveDown = Bool(false)
  var isMovingDown = Bool(false)
  
  init(length: CGFloat) {
    super.init()
    
    //calculate platform dimensions based on screen size
    self.length = length
    edgeHeight = thickness*2
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
    let mutablePath = CGPathCreateMutable()
    CGPathMoveToPoint(mutablePath, nil, -length/2, 0)
    CGPathAddLineToPoint(mutablePath, nil, length/2, 0)
    CGPathAddLineToPoint(mutablePath, nil, length/2 + edgeHeight/sqrt(2), edgeHeight/sqrt(2))
    CGPathAddLineToPoint(mutablePath, nil, length/2 + (edgeHeight-thickness)/sqrt(2), (edgeHeight+thickness)/sqrt(2))
    CGPathAddLineToPoint(mutablePath, nil, length/2 - thickness*tan(radians(22.5)), thickness)
    CGPathAddLineToPoint(mutablePath, nil, -(length/2 - thickness*tan(radians(22.5))), thickness)
    CGPathAddLineToPoint(mutablePath, nil, -length/2 - (edgeHeight-thickness)/sqrt(2), (edgeHeight+thickness)/sqrt(2))
    CGPathAddLineToPoint(mutablePath, nil, -(length/2 + edgeHeight/sqrt(2)), edgeHeight/sqrt(2))
    CGPathCloseSubpath(mutablePath)
    path = mutablePath
    
    super.build(true, path: self.path)
    
    if isPermeable {fillColor = currentTheme.permeablePlatformColor(length)}
    else {fillColor = currentTheme.impermeablePlatformColor(length)}
    if doesMoveDown {strokeColor = currentTheme.movingPlatformStrokeColor; lineWidth = 2; glowWidth = 0.5}
    
  }
  
}
