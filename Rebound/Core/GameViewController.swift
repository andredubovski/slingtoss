//
//  GameViewController.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright (c) 2016 oakl.in. All rights reserved.
//

import UIKit
import SpriteKit

var gameScene = GameScene()
var settingsScene = SettingsScene()

var defaults = NSUserDefaults()
var path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
var config = NSDictionary(contentsOfFile: path!)

func configValueForKey(key: String) -> CGFloat {
  return CGFloat(config!.objectForKey(key) as! NSNumber)
}

func configBoolForKey(key: String) -> Bool {
  return config!.objectForKey(key) as! Bool
}

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Configure the view.
    let skView = self.view as! SKView
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
//    skView.showsNodeCount = true
    
    /* Set the scale mode to scale to fit the window */
    assembleThemes()
    
    settingsScene.scaleMode = .ResizeFill
    gameScene.scaleMode = .ResizeFill
    
    skView.presentScene(gameScene)
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return .AllButUpsideDown
    } else {
      return .All
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
