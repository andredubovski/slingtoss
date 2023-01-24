//
//  SettingsScene.swift
//
//
//  Created by Andre Dubovskiy on 11/24/17.
//
//

import SpriteKit
import AVFoundation


class MenuScene: SKScene {
  
  var menu = MainMenu()
  var tutorial = Tutorial(imageNamed: "tutorial")
  
  var isVirgin = Bool(true)
  
  override func didMove(to view: SKView) {
    
    name = "menu scene"
    gameScene.ataBanner.isHidden = true
    if isVirgin {
//      currentTheme.build(self)
      setup()
      isVirgin = false
    }
    
  }
  
  private func setup() {
      
      if defaults.value(forKey: "SFX") == nil {defaults.set(true, forKey: "SFX")}
      if defaults.value(forKey: "Music") == nil {defaults.set(true, forKey: "Music")}
      if defaults.value(forKey: "Ads") == nil {defaults.set(true, forKey: "Ads")}
      
      currentTheme.build()
      if defaults.bool(forKey: "Ads") {setupAdToApp()}
      gameFrame = frame
      if gameFrame.width > 500 {physicsWorld.speed = 1.45}
      let audioSession = AVAudioSession.sharedInstance()
      do {try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: .duckOthers)}
      catch {print("AVAudioSession cannot be set: \(error)")}
      beginBgMusic()
      buildBounceSound()
      buildGameOverSound()
      
      menu.build(self)
      tutorial.build(scene: self)

      menu.appear()
    
      if !defaults.bool(forKey: "hasShownTutorial") {
        run(SKAction.sequence([
          SKAction.wait(forDuration: 0.6),
          SKAction.run({self.tutorial.show()})
          ]))
        defaults.set(true, forKey: "hasShownTutorial")
      }
      
      settingsScene.didMove(to: view!)
      
    
  }
  
  func beginBgMusic() {
    let path = Bundle.main.path(forResource: "StrangeGreenPlanet.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      gameScene.backgroundMusicPlayer = sound
      gameScene.backgroundMusicPlayer.numberOfLoops = -1
      gameScene.backgroundMusicPlayer.prepareToPlay()
      gameScene.backgroundMusicPlayer.play()
    } catch {
      fatalError("couldn't load music file")
    }
    
    gameScene.backgroundMusicPlayer.volume = defaults.bool(forKey: "Music") ? 0.24 : 0
  }
  
  func buildBounceSound() {
    let path = Bundle.main.path(forResource: "Bounce.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    for _ in 0...1 {
      do {
        let sound = try AVAudioPlayer(contentsOf: url)
        sound.prepareToPlay()
        gameScene.bouncePlayer.append(sound)
      } catch {
        fatalError("couldn't load music file")
      }
    }
  }
  
  func buildGameOverSound() {
    let path = Bundle.main.path(forResource: "GameOver.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      gameScene.gameOverPlayer = sound
      gameScene.gameOverPlayer.volume = 1
      gameScene.gameOverPlayer.prepareToPlay()
    } catch {
      fatalError("couldn't load music file")
    }
  }
  
  func setupAdToApp() {
    
    //Uncomment the line below if you need test mode
    //    AdToAppSDK.enableTestMode()
    //Uncomment the line below if you need logs
    //    AdToAppSDK.enableDebugLogs()
    AdToAppSDK.setDelegate(gameScene)
    AdToAppSDK.start(withAppId: "e41a7f3d-7104-47c3-8dbf-ddcc0541020b:0d1b5786-7d2d-4495-bc82-9dfa56e5f675", modules:[
      ADTOAPP_IMAGE_INTERSTITIAL,
      ADTOAPP_VIDEO_INTERSTITIAL,
      ADTOAPP_INTERSTITIAL,
      //ADTOAPP_REWARDED_INTERSTITIAL,
      ADTOAPP_BANNER
      ])
    
    gameScene.ataBanner = AdToAppView.attach(to: gameScene.view, position:ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets:UIEdgeInsets.zero, bannerSize:ADTOAPPSDK_BANNER_SIZE_320x50, delegate:gameScene) as! AdToAppView
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      if tutorial.isShowing {tutorial.doWhenTouchesBegan(); return}
      menu.doWhenTouchesBegan(location)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      menu.doWhenTouchesMoved(location)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let location = touch.location(in: self)
      if tutorial.isShowing {tutorial.doWhenTouchesEnded(); return}
      menu.doWhenTouchesEnded(location)
    }
  }
  
}

