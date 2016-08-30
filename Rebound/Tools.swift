//
//  Tools.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

let uiColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.6)
let uiHighlightColor = SKColor.blackColor()//(red: 0, green: 0, blue: 0, alpha: 0.6)

let fadeIn = SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0), SKAction.fadeAlphaTo(1, duration: 0.7)])

let fadeOut = SKAction.fadeAlphaTo(0, duration: 0.7)

func random(from: CGFloat, to: CGFloat) -> CGFloat {
  return from + (CGFloat(arc4random()) * (to-from)) / (pow(2.0, 32.0))
}

func radians(degrees: CGFloat) -> CGFloat {
  return CGFloat(M_PI) * (degrees/180)
}

struct PhysicsCategory {
  static let Ball: UInt32 = 0x1 << 1
  static let Terrain: UInt32 = 0x1 << 2
  static let ImpermeableTerrain: UInt32 = 0x1 << 3
  static let Wall: UInt32 = 0x1 << 4
}

func magnitude(vector: CGVector) -> CGFloat {
  return sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))
}

func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
  return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}

func vectorFromAngleMagnitude(angle: CGFloat, magnitude: CGFloat) -> CGVector {
  return CGVectorMake(magnitude * sin(angle), magnitude * cos(angle))
}

public func + (p1: CGPoint, p2: CGPoint) -> CGPoint {
  return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}
public func - (p1: CGPoint, p2: CGPoint) -> CGPoint {
  return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}
public func * (p1: CGPoint, p2: CGPoint) -> CGPoint {
  return CGPoint(x: p1.x * p2.x, y: p1.y * p2.y)
}
public func / (p1: CGPoint, p2: CGPoint) -> CGPoint {
  return CGPoint(x: p1.x / p2.x, y: p1.y / p2.y)
}

//cast integers as booleans, (true -> false, nonzero -> true)
extension Bool {
  init<T : IntegerType>(_ integer: T){
    self.init(integer != 0)
  }
}

func degrees (value:CGFloat) -> CGFloat {
  return value * 180.0 / CGFloat(M_PI)
}

//get red value of given UI- or SKColor

public func redValue(color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(r)
  }
  return 0.0
}

public func greenValue(color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(g)
  }
  return 0.0
}

public func blueValue(color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(b)
  }
  return 0.0
}

public func alphaValue(color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(a)
  }
  return 0.0
}

func makeSettingsNode() -> SKSpriteNode{
  return SKSpriteNode(imageNamed: "settings")
}

//info node for main menu
func makeInfoNode() -> SKSpriteNode {
  return SKSpriteNode(imageNamed: "info")
}
