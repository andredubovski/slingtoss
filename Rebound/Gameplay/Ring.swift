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
  var radius = CGFloat()
  
  init(radius: CGFloat) {
    super.init()
    
    //calculate platform dimensions based on screen size
    self.radius = radius
  }
  
  convenience init(radius: CGFloat, position: CGPoint) {
    self.init(radius: radius)
    self.position = position
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func build() {
    
    name = "ring"
    //create path that has platform shape based on dimensions
    let mutablePath = CGMutablePath()
    mutablePath.move(to: CGPoint(x: 0, y: 0))
    CGPathAddEllipseInRect(mutablePath, nil, CGRect(x: -radius, y: 0, width: radius*2, height: radius*2))
    CGPathAddEllipseInRect(mutablePath, nil, CGRect(x: -(radius-thickness), y: thickness, width: (radius-thickness)*2, height: (radius-thickness)*2))
    mutablePath.closeSubpath()
    path = mutablePath
    
    let randomRadius = random(configValueForKey("Min relative ring radius"), to: configValueForKey("Max relative ring radius")) * gameFrame.width
    fillColor = currentTheme.ringColor(randomRadius)
    
    let physicsPath = CGMutablePath()
    CGPathAddArc(physicsPath, nil, 0, radius, radius, radians(-90), radians(270), false)
    CGPathAddArc(physicsPath, nil, 0, radius, radius-thickness, radians(270), radians(-90), true)
    physicsPath.closeSubpath()

    super.build(physicsPath)
    
  }

}
