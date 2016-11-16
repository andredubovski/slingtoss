//
//  GameScene.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright (c) 2016 oakl.in. All rights reserved.
//

import SpriteKit
import AVFoundation

var gameFrame = CGRect()
let blankView = UIView()

class GameScene: SKScene, SKPhysicsContactDelegate, AdToAppViewDelegate, AdToAppSDKDelegate {
  
  var isVirgin = Bool(true)
  var menu = MainMenu()
  var deathMenu = DeathMenu()
  var onDeathMenu = Bool(false)
  var resetCount = Int(0)
  let terrains = TerrainController()
  let ball = Ball()
  let slingshot = Slingshot()
  let score = Score()
  
  let scrollThresholdOnScreen = configValueForKey("Relative scroll threshold")
  var verticalProgress = CGFloat(0)
  
  var adsOn = defaults.bool(forKey: "Ads")
  var atpActive = Bool(true)
  var atpPlaceholderActive = Bool(false)
  
  var backgroundMusicPlayer: AVAudioPlayer! = nil
  var bouncePlayerIndex = Int(0)
  var bouncePlayer = [AVAudioPlayer!]()
  var gameOverPlayer: AVAudioPlayer! = nil
  
  override func didMove(to view: SKView) {
    
    if isVirgin {gameSetup(); isVirgin = false}
    
  }
  
  fileprivate func gameSetup() {
    
    currentTheme.build()
    if defaults.bool(forKey: "Ads") {setupAdToApp()}
    setupSound()
    physicsWorld.contactDelegate = self
    gameFrame = frame
    if gameFrame.width > 500 {physicsWorld.speed = 1.45}
    
    menu.build()
    deathMenu.build()
    ball.build()
    slingshot.build()
    terrains.build()
    score.build()
    
    reset()
    if !onDeathMenu {
      deathMenu.hide()
      menu.appear()
    }
    
    buildWalls()
    
  }
  
  func buildWalls() {
    for i in 0...1 {
      let wall = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 1, height: frame.height))
      wall.position = CGPoint(x: CGFloat(i)*frame.width, y: frame.midY)
      wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
      physicsBody?.contactTestBitMask = PhysicsCategory.Ball
      wall.name = "wall"
      wall.physicsBody!.isDynamic = false
      wall.physicsBody!.restitution = 0.7
      addChild(wall)
    }
  }
  
  fileprivate func reset() {
    
    terrains.reset(ball, menu: menu.isActive ? menu:deathMenu)
    ball.reset()
    
    scroll(0)
    deathMenu.appear(score: score)
    score.reset()
    verticalProgress = 0
    currentTheme.background.reset()
    
    flashDeathOverlay()
    if defaults.bool(forKey: "SFX") && !isVirgin {gameOverPlayer.play()}
    
    
    resetCount += 1
    
  }
  
  func flashDeathOverlay() {
    let deathScreen = SKSpriteNode(color: currentTheme.tintColor, size: frame.size)
    deathScreen.position = CGPoint(x: frame.midX, y: frame.midY)
    deathScreen.zPosition = 234
    addChild(deathScreen)
    deathScreen.run(SKAction.fadeAlpha(to: 0, duration: 1))
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.location(in: self)
      if menu.isActive {menu.doWhenTouchesBegan(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesBegan(touchLocation)}
      if slingshot.canShoot && !menu.wasPressed && !deathMenu.wasPressed {
        ball.physicsBody?.isResting = true
        slingshot.aim(ball, atPoint: touchLocation)
        if defaults.bool(forKey: "SFX") {
          slingshot.playAppropriateAimSound()
        }
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.location(in: self)
      if menu.isActive {menu.doWhenTouchesMoved(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesMoved(touchLocation)}
      if slingshot.canShoot && !menu.wasPressed && !deathMenu.wasPressed {slingshot.aim(ball, atPoint: touchLocation)}
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    var shot = Bool(false)
    if !menu.wasPressed && !deathMenu.wasPressed {shot = slingshot.shoot(terrains.current, ball: ball)}
    
    for touch in touches {
      let touchLocation = touch.location(in: self)
      if menu.isActive {
        menu.doWhenTouchesEnded(touchLocation, shot: shot)
      }
      if deathMenu.isActive {
        deathMenu.doWhenTouchesEnded(touchLocation, shot: shot)
        if shot {
          terrains.array[2]?.appear()
        }
      }
      
      if touch.tapCount == 2 {
        doubleTapped()
      }
    }
    
    if touches.count == 2 {
      twoFingerTapped()
    }
    
    if shot && score.box.alpha < 0.5 {
      score.appear()
    }
  }
  
  
  func twoFingerTapped() {
    AdToAppSDK.showInterstitial(ADTOAPP_INTERSTITIAL)
  }
  
  func doubleTapped() {
//    let defaults = UserDefaults()
//    defaults.set(defaults.integer(forKey: "theme") + 1 < themes.count ? defaults.integer(forKey: "theme") + 1 : 0, forKey: "theme")
    
//    banner.isHidden = !banner.isHidden
//    
////    terrains.array[terrains.currentIndex] = nil
//    
//    defaults.set(0, forKey: "high score")
    
  }
  
  
  fileprivate func scroll(_ interval: CGFloat) {
    if menu.isActive {menu.disappear(); score.appear()}
    if deathMenu.isActive {deathMenu.disappear(); score.appear()}
    currentTheme.background.scroll(interval)
    terrains.scroll(interval, progress: verticalProgress, ball: ball, score: score)
    ball.scroll(interval)
    slingshot.scroll(interval, ball: ball)
    
    verticalProgress += interval
  }

  override func update(_ currentTime: TimeInterval) {
    if ball.position.y < 0 {reset()}
    let interval = ball.position.y - frame.height*scrollThresholdOnScreen
    if interval > 0 {scroll(interval)}
    ball.update(terrains)
    slingshot.update(terrains.current, ball: ball)
    if score.amount == 1 && terrains.array[2]!.alpha < 0.1 {
      terrains.array[2]?.appear()
    }
  }
  
  
  func getScreenShot() -> UIImage {
    let bounds = UIScreen.main.bounds
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    self.view!.drawHierarchy(in: bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return img!
    
  }
  
  
  func didBegin(_ contact: SKPhysicsContact) {
    if contact.collisionImpulse > 1.89 && defaults.bool(forKey: "SFX") {
      if ((contact.bodyA.node!.name == "ball" && contact.bodyB.node!.name == "permeable platform") ||
        (contact.bodyB.node!.name == "ball" && contact.bodyA.node!.name == "permeable platform") ||
        (contact.bodyA.node!.name == "ball" && contact.bodyB.node!.name == "ring") ||
        (contact.bodyB.node!.name == "ball" && contact.bodyA.node!.name == "ring"))
        &&
        ball.collidingWithPermeable {
          playBounceSound(contact.collisionImpulse/8<=1 ? contact.collisionImpulse/8 : 1)
      }
      
      if (contact.bodyA.node!.name == "ball" && contact.bodyB.node!.name == "impermeable platform") ||
        (contact.bodyB.node!.name == "ball" && contact.bodyA.node!.name == "impermeable platform") ||
        (contact.bodyA.node!.name == "ball" && contact.bodyB.node!.name == "wall") ||
        (contact.bodyB.node!.name == "ball" && contact.bodyA.node!.name == "wall") {
        playBounceSound(contact.collisionImpulse/5<=1 ? contact.collisionImpulse/5 : 1)
      }
    }
  }
  
  
  func beginBgMusic() {
    let path = Bundle.main.path(forResource: "StrangeGreenPlanet.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      backgroundMusicPlayer = sound
      backgroundMusicPlayer.numberOfLoops = -1
      backgroundMusicPlayer.prepareToPlay()
      backgroundMusicPlayer.play()
    } catch {
      fatalError("couldn't load music file")
    }
    
    backgroundMusicPlayer.volume = defaults.bool(forKey: "Music") ? 0.24 : 0
  }
  
  func buildBounceSound() {
    let path = Bundle.main.path(forResource: "Bounce.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    for _ in 0...1 {
      do {
        let sound = try AVAudioPlayer(contentsOf: url)
        sound.prepareToPlay()
        bouncePlayer.append(sound)
      } catch {
        fatalError("couldn't load music file")
      }
    }
  }
  
  func playBounceSound(_ volume: CGFloat) {
    let previousIndex = bouncePlayerIndex - 1 >= 0 ? bouncePlayerIndex - 1 : 1
    if bouncePlayer[previousIndex].isPlaying {
      if bouncePlayer[previousIndex].currentTime > 0.1 {
        bouncePlayer[bouncePlayerIndex].volume = Float(volume)
        bouncePlayer[bouncePlayerIndex].play()
      }
    }
    else {
      bouncePlayer[bouncePlayerIndex].volume = Float(volume)
      bouncePlayer[bouncePlayerIndex].play()
    }
    
    bouncePlayerIndex += 1
    if bouncePlayerIndex > 1 {bouncePlayerIndex = 0}
  }
  
  func buildGameOverSound() {
    let path = Bundle.main.path(forResource: "GameOver.m4a", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      gameOverPlayer = sound
      gameOverPlayer.volume = 1
      gameOverPlayer.prepareToPlay()
    } catch {
      fatalError("couldn't load music file")
    }
  }

  func setupSound() {
    let audioSession = AVAudioSession.sharedInstance()
    do {try audioSession.setCategory(AVAudioSessionCategoryAmbient, with: .duckOthers)}
    catch {print("AVAudioSession cannot be set: \(error)")}
    beginBgMusic()
    buildBounceSound()
    buildGameOverSound()
  }
  
  func setupAdToApp() {

    //Uncomment the line below if you need test mode
    AdToAppSDK.enableTestMode()
    //Uncomment the line below if you need logs
    AdToAppSDK.enableDebugLogs()
    AdToAppSDK.setDelegate(self)
    AdToAppSDK.start(withAppId: "39c3f1a3-bced-4ae4-851b-7cb603a44479:c4050a11-a7eb-4733-b961-7d77c7601aee", modules:[
      ADTOAPP_IMAGE_INTERSTITIAL,
      ADTOAPP_VIDEO_INTERSTITIAL,
      ADTOAPP_INTERSTITIAL,
      //ADTOAPP_REWARDED_INTERSTITIAL,
      ADTOAPP_BANNER
      ])
    
    AdToAppView.attach(to: self.view, position:ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets:UIEdgeInsets.zero, bannerSize:ADTOAPPSDK_BANNER_SIZE_320x50, delegate:self)
    
  }
  
  func ad(_ adToAppView: AdToAppView!, failedToDisplayAdWithError error: Error!, isConnectionError: Bool) {
    return
  }
  
  func ad(toAppViewDidDisplayAd adToAppView: AdToAppView!, providerId: Int32) {
    return
  }
  
  
  func onAdWillAppear(_ adType: String, providerId: Int32) {
    NSLog("On interstitial show")
  }
  
  func onAdDidDisappear(_ adType: String, providerId: Int32) {
    NSLog("On interstitial hide")
  }
  
  //optional
  func onReward(_ reward: Int32, currency gameCurrency: String!, providerId: Int32) {
    NSLog("On reward")
  }
  
  //optional
  private func shouldShowAd(adType: String)-> Bool {
    NSLog("On should show Ad")
    
    return true;
  }
  
}
