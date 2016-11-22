//
//  Tools.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import SpriteKit

let fadeIn = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0), SKAction.fadeAlpha(to: 1, duration: 0.7)])

let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.7)

func random(_ from: CGFloat, to: CGFloat) -> CGFloat {
  return from + (CGFloat(arc4random()) * (to-from)) / (pow(2.0, 32.0))
}

func weightedRandom(_ from: CGFloat, to: CGFloat, weight: CGFloat) -> CGFloat {
  var p = (1-weight)//2 + 0.25
  if p == 0.5 {p = 0.49999999}
  
  let max = to - from
  let a = (4 - 8*p) / pow(max, 2)
  let b = (4*p - 1) / (max)
  let x = random(0, to: 1)
  let f = (-b + sqrt(pow(b, 2) + 2*a*x)) / a
  
  return from + f
}

func radians(_ degrees: CGFloat) -> CGFloat {
  return CGFloat(M_PI) * (degrees/180)
}

struct PhysicsCategory {
  static let Ball: UInt32 = 0x1 << 1
  static let Terrain: UInt32 = 0x1 << 2
  static let ImpermeableTerrain: UInt32 = 0x1 << 3
  static let Wall: UInt32 = 0x1 << 4
}

func magnitude(_ vector: CGVector) -> CGFloat {
  return sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))
}

func distance(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
  return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}

func vectorFromAngleMagnitude(_ angle: CGFloat, magnitude: CGFloat) -> CGVector {
  return CGVector(dx: magnitude * sin(angle), dy: magnitude * cos(angle))
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
  init<T : Integer>(_ integer: T){
    self.init(integer != 0)
  }
}

func degrees (_ value:CGFloat) -> CGFloat {
  return value * 180.0 / CGFloat(M_PI)
}

//get red value of given UI- or SKColor

public func redValue(_ color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(r)
  }
  return 0.0
}

public func greenValue(_ color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(g)
  }
  return 0.0
}

public func blueValue(_ color: SKColor) -> CGFloat {
  var r:CGFloat = 0
  var g:CGFloat = 0
  var b:CGFloat = 0
  var a:CGFloat = 0
  if color.getRed(&r, green: &g, blue: &b, alpha: &a){
    return CGFloat(b)
  }
  return 0.0
}

public func alphaValue(_ color: SKColor) -> CGFloat {
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


func tintImage(_ image: inout UIImage, color: UIColor) {
  UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
  color.setFill()
  
  let context = UIGraphicsGetCurrentContext()! as CGContext
  context.translateBy(x: 0, y: image.size.height)
  context.scaleBy(x: 1.0, y: -1.0);
  context.setBlendMode(CGBlendMode.normal)
  
  let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) as CGRect
  context.clip(to: rect, mask: image.cgImage!)
  context.fill(rect)
  
  image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
  UIGraphicsEndImageContext()
}

func popup(scene: SKScene, title: String, message: String) {
  if let gvc = scene.view?.window?.rootViewController! as? GameViewController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    gvc.present(alert, animated: true, completion: nil)
  }
}

extension String {
  func indexes(of string: String, options: String.CompareOptions = .literal) -> [String.Index] {
    var result: [String.Index] = []
    var start = startIndex
    while let range = range(of: string, options: options, range: start..<endIndex, locale: nil) {
      result.append(range.lowerBound)
      start = range.upperBound
    }
    return result
  }
}

//extension Collection {
//  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
//  subscript (safe index: Index) -> Iterator.Element? {
//    return indices.contains(index) ? self[index] : nil
//  }
//}
