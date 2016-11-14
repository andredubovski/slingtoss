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

var defaults = UserDefaults()
var path = Bundle.main.path(forResource: "Config", ofType: "plist")
var config = NSDictionary(contentsOfFile: path!)

func configValueForKey(_ key: String) -> CGFloat {
  return CGFloat(config!.object(forKey: key) as! NSNumber)
}

func configBoolForKey(_ key: String) -> Bool {
  return config!.object(forKey: key) as! Bool
}

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Configure the view.
    let skView = self.view as! SKView
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
//    skView.showsFPS = true
//    skView.showsNodeCount = true
    
    /* Set the scale mode to scale to fit the window */
    assembleThemes()
    
    settingsScene.scaleMode = .resizeFill
    gameScene.scaleMode = .resizeFill
    
    skView.presentScene(gameScene)
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
}
