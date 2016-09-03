//
//  Ring.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/29/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit


class Ring: Terrain {
  
  //various dimensions of platform
  var thickness = CGFloat()
  var radius = CGFloat()
  
  init(radius: CGFloat) {
    super.init()
    
    //calculate platform dimensions based on screen size
    self.radius = radius
    thickness = gameFrame.width*0.046875
  }
  
  convenience init(radius: CGFloat, position: CGPoint) {
    self.init(radius: radius)
    self.position = position
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func build() {
    
    //create path that has platform shape based on dimensions
    let mutablePath = CGPathCreateMutable()
    CGPathMoveToPoint(mutablePath, nil, 0, 0)
    CGPathAddArc(mutablePath, nil, 0, radius, radius, radians(-90), radians(270), false)
    CGPathAddArc(mutablePath, nil, 0, radius, radius-thickness, radians(-90), radians(270), false)
    CGPathCloseSubpath(mutablePath)
    path = mutablePath
    
    
    fillColor = currentTheme.ringColor(radius)
    
    super.build()
    
  }

}