//
//  GameViewController.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright (c) 2016 witehat.com. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import StoreKit

var menuScene = MenuScene()
var gameScene = GameScene()
var settingsScene = SettingsScene()
var creditsScene = CreditsScene()

var defaults = UserDefaults()
var path = Bundle.main.path(forResource: "Config", ofType: "plist")
var config = NSDictionary(contentsOfFile: path!)

func configNumberForKey(_ key: String) -> CGFloat {
  return CGFloat(config!.object(forKey: key) as! NSNumber)
}

func configStringForKey(_ key: String) -> String {
  return config!.object(forKey: key) as! String
}

func configBoolForKey(_ key: String) -> Bool {
  return config!.object(forKey: key) as! Bool
}

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
  
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
    
    menuScene.scaleMode = .resizeFill
    settingsScene.scaleMode = .resizeFill
    gameScene.scaleMode = .resizeFill
    creditsScene.scaleMode = .resizeFill
    
    skView.presentScene(menuScene)
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
  
  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
}
