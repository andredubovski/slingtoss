//
//  GameScene.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright (c) 2016 oakl.in. All rights reserved.
//

import SpriteKit

var gameFrame = CGRect()
class GameScene: SKScene {
    
  var isVirgin = Bool(true)
  var menu = MainMenu()
  var deathMenu = DeathMenu()
  
  let bg = Background()
  let terrains = TerrainController()
  let ball = Ball()
  let slingshot = Slingshot()
  let score = Score()
  
  let scrollThresholdOnScreen = CGFloat(0.36)
  var verticalProgress = CGFloat(0)
  
  override func didMoveToView(view: SKView) {
    print("did move to view")
    if isVirgin {gameSetup(); isVirgin = false}
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    tap.numberOfTapsRequired = 2
    view.addGestureRecognizer(tap)
  }
  
  private func gameSetup() {
    
    gameFrame = frame
    
    menu.build()
    deathMenu.build()
    bg.build()
    ball.build()
    slingshot.build()
    terrains.build()
    score.build()
    
    reset()
    deathMenu.hide()
    menu.appear()
    
    for i in 0...1 {
      let wall = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(1, frame.height))
      wall.position = CGPointMake(CGFloat(i)*frame.width, frame.midY)
      wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
      wall.physicsBody!.dynamic = false
      wall.physicsBody!.restitution = 0.7
      addChild(wall)
    }
  }
  
  private func reset() {
//    let deathScreen = SKSpriteNode(color: SKColor.whiteColor(), size: frame.size)
//    deathScreen.position = CGPoint(x: frame.midX, y: frame.midY)
//    deathScreen.zPosition = 234
//    addChild(deathScreen)
//    deathScreen.runAction(SKAction.fadeAlphaTo(0, duration: 1))
    
    terrains.reset(ball, menu: menu.isActive ? menu:deathMenu)
    ball.reset()
    
    scroll()
    deathMenu.appear()
    score.reset()
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {menu.doWhenTouchesBegin(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesBegin(touchLocation)}
      if slingshot.canShoot && !menu.wasPressed && !deathMenu.wasPressed {slingshot.aim(ball, atPoint: touchLocation)}
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {menu.doWhenTouchesMoved(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesMoved(touchLocation)}
      if slingshot.canShoot && !menu.wasPressed && !deathMenu.wasPressed {slingshot.aim(ball, atPoint: touchLocation)}
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    if !menu.wasPressed && !deathMenu.wasPressed {slingshot.shoot(ball)}
    
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {menu.doWhenTouchesEnded(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesEnded(touchLocation)}
    }
  }
  
  
  func doubleTapped() {
//    reset()
  }
  
  func getScreenShot() -> UIImage {
    let bounds = UIScreen.mainScreen().bounds
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    self.view!.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return img
    
  }
  
  private func scroll() {
    let interval = ball.position.y - frame.height*scrollThresholdOnScreen
    if menu.isActive {menu.disappear(); score.appear()}
    if deathMenu.isActive {deathMenu.disappear(); score.appear()}
    bg.scroll(interval)
    ball.scroll(interval)
    terrains.scroll(interval, progress: verticalProgress, ball: ball, score: score)
    slingshot.scroll(interval, ball: ball)
    
    verticalProgress += interval
  }
  
  override func update(currentTime: CFTimeInterval) {
    if ball.position.y > frame.height*scrollThresholdOnScreen {scroll()}
    ball.update(terrains)
    slingshot.update(ball)
    if ball.position.y < 0 {reset()}
  }
}
