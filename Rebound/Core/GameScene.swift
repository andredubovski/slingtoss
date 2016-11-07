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

class GameScene: SKScene, SKPhysicsContactDelegate, AdToAppSDKDelegate, AdToAppViewDelegate {
  
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
  var atpView = AdToAppView()
  var atpActive = Bool(true)
  var atpPlaceholderActive = Bool(false)
  
  var backgroundMusicPlayer: AVAudioPlayer! = nil
  var bouncePlayerIndex = Int(0)
  var bounceSoundPlayer = [AVAudioPlayer!]()
  var gameOverSoundPlayer: AVAudioPlayer! = nil
  
  override func didMove(to view: SKView) {
    
    if isVirgin {gameSetup(); isVirgin = false}
    
  }
  
  fileprivate func gameSetup() {
    
    currentTheme.build()
    setupAdToApp()
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
    deathMenu.appear(score.amount)
    score.reset()
    verticalProgress = 0
    currentTheme.background.reset()
    
    flashDeathOverlay()
    if defaults.bool(forKey: "SFX") && !isVirgin {gameOverSoundPlayer.play()}
    
    let randomAdSelector = Int(random(0, to: 100))
    if randomAdSelector < 18 {AdToAppSDK.showInterstitial(ADTOAPP_IMAGE_INTERSTITIAL)}
    else if randomAdSelector > 88 {AdToAppSDK.showInterstitial(ADTOAPP_VIDEO_INTERSTITIAL)}
    
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
          terrains.array[2]!.appear()
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
    let defaults = UserDefaults()
    defaults.set(defaults.integer(forKey: "theme") + 1 < themes.count ? defaults.integer(forKey: "theme") + 1 : 0, forKey: "theme")
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
    if contact.collisionImpulse > 0.45 && defaults.bool(forKey: "SFX") {
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
    let path = Bundle.main.path(forResource: "Bounce.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    for _ in 0...2 {
      do {
        let sound = try AVAudioPlayer(contentsOf: url)
        sound.prepareToPlay()
        bounceSoundPlayer.append(sound)
      } catch {
        fatalError("couldn't load music file")
      }
    }
  }
  
  func playBounceSound(_ volume: CGFloat) {
    let previousIndex = bouncePlayerIndex - 1 >= 0 ? bouncePlayerIndex - 1 : 2
    if bounceSoundPlayer[previousIndex].isPlaying {
      if bounceSoundPlayer[previousIndex].currentTime > 0.1 {
        bounceSoundPlayer[bouncePlayerIndex].volume = Float(volume)
        bounceSoundPlayer[bouncePlayerIndex].play()
      }
    }
    else {
      bounceSoundPlayer[bouncePlayerIndex].volume = Float(volume)
      bounceSoundPlayer[bouncePlayerIndex].play()
    }
    
    bouncePlayerIndex += 1
    if bouncePlayerIndex > 2 {bouncePlayerIndex = 0}
  }
  
  func buildGameOverSound() {
    let path = Bundle.main.path(forResource: "GameOver.mp3", ofType:nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOf: url)
      gameOverSoundPlayer = sound
      gameOverSoundPlayer.volume = 0.4
      gameOverSoundPlayer.prepareToPlay()
    } catch {
      fatalError("couldn't load music file")
    }
  }

  func setupSound() {
    beginBgMusic()
    buildBounceSound()
    buildGameOverSound()
  }
  
  
  func setupAdToApp() {
    if adsOn {
      AdToAppSDK.start(
        withAppId: "39c3f1a3-bced-4ae4-851b-7cb603a44479:c4050a11-a7eb-4733-b961-7d77c7601aee",
        modules:[
          ADTOAPP_IMAGE_INTERSTITIAL,
          ADTOAPP_VIDEO_INTERSTITIAL,
          ADTOAPP_INTERSTITIAL,
          //ADTOAPP_REWARDED_INTERSTITIAL,//Uncomment to test rewarded ads
          ADTOAPP_BANNER
        ]
      )
    }
    
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_KEYWORDS, "advertisement,mobile ads,ads mediation");
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_INTERESTS, "ecpm,revenue");
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_BIRTHDAY, "1.01.1990");
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_AGE, "25");
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_GENDER, ADTOAPP_TARGETING_PARAM_USER_GENDER_MALE);
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_OCCUPATION, ADTOAPP_TARGETING_PARAM_USER_OCCUPATION_UNIVERSITY);
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_RELATIONSHIP, ADTOAPP_TARGETING_PARAM_USER_RELATIONSHIP_ENGAGED);
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_LATITUDE, "26.71234");
    AdToAppSDK_setTargetingParam(ADTOAPP_TARGETING_PARAM_USER_LONGITUDE, "-80.051595");
    
    AdToAppView.attach(to: view, position: ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets: UIEdgeInsets.zero, bannerSize: ADTOAPPSDK_BANNER_SIZE_320x50, delegate: self)
    let banner:AdToAppView = AdToAppView.attach(to: self.view, position:ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets:UIEdgeInsets.zero, bannerSize:ADTOAPPSDK_BANNER_SIZE_320x50, delegate:self) as! AdToAppView
    banner.setRefreshInterval(25.0)
    
    showAdPlaceholder()
  }
  
  func ad(toAppViewDidDisplayAd _: AdToAppView!, providerId: Int32) {
    return
  }
  
  func showAdPlaceholder() {
    if !atpPlaceholderActive && adsOn {
      let adPlaceholder = SKSpriteNode(imageNamed: "adPlaceholder")
      adPlaceholder.position = CGPoint(x: frame.midX, y: adPlaceholder.frame.height/2)
      adPlaceholder.zPosition = 2
      addChild(adPlaceholder)
      atpPlaceholderActive = true
    }
  }
  
  func ad(_ adToAppView: AdToAppView!, failedToDisplayAdWithError error: Error!, isConnectionError: Bool) {
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
  func shouldShowAd(_ adType: String)-> Bool {
    NSLog("On shoud show Ad")
    
    return true;
  }
  
  //optional
  func onAdClicked(_ adType: String!, providerId: Int32) {
    NSLog("On Ad clicked")
  }
  
  //optional
  func onAdFailed(toAppear adType: String!) {
    NSLog("On Ad failed to appear")
  }
  
  //optional
  func onFirstAdLoaded(_ adType: String!) {
    NSLog("On First Ad Loaded")
  }
  
}
