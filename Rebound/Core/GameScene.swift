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
  let terrains = TerrainController()
  let ball = Ball()
  let slingshot = Slingshot()
  let score = Score()
  
  let scrollThresholdOnScreen = CGFloat(0.33)
  var verticalProgress = CGFloat(0)
  
  var adsOn = defaults.boolForKey("Ads")
  var atpView = AdToAppView()
  var atpActive = Bool(true)
  var atpPlaceholderActive = Bool(false)
  
  var backgroundMusicPlayer:AVAudioPlayer! = nil
  var bouncePlayerIndex = Int(0)
  var bounceSoundPlayer = [AVAudioPlayer!]()
  
  override func didMoveToView(view: SKView) {
    
    if isVirgin {gameSetup(); isVirgin = false}
    
  }
  
  private func gameSetup() {
    
    currentTheme.build()
    setupAdToApp()
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
    deathMenu.hide()
    menu.appear()
    
    buildWalls()
    setupSound()
    
  }
  
  func buildWalls() {
    for i in 0...1 {
      let wall = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(1, frame.height))
      wall.position = CGPointMake(CGFloat(i)*frame.width, frame.midY)
      wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
      physicsBody?.contactTestBitMask = PhysicsCategory.Ball
      wall.name = "wall"
      wall.physicsBody!.dynamic = false
      wall.physicsBody!.restitution = 0.7
      addChild(wall)
    }
  }
  
  private func reset() {
    
    terrains.reset(ball, menu: menu.isActive ? menu:deathMenu)
    ball.reset()
    
    scroll(0)
    deathMenu.appear(score.amount)
    score.reset()
    verticalProgress = 0
    currentTheme.background.reset()
    
    flashDeathOverlay()
    
    let randomAdSelector = Int(random(0, to: 100))
    if randomAdSelector < 18 {AdToAppSDK.showInterstitial(ADTOAPP_IMAGE_INTERSTITIAL)}
    else if randomAdSelector > 88 {AdToAppSDK.showInterstitial(ADTOAPP_VIDEO_INTERSTITIAL)}
    
  }
  
  
  func flashDeathOverlay() {
    let deathScreen = SKSpriteNode(color: currentTheme.tintColor, size: frame.size)
    deathScreen.position = CGPoint(x: frame.midX, y: frame.midY)
    deathScreen.zPosition = 234
    addChild(deathScreen)
    deathScreen.runAction(SKAction.fadeAlphaTo(0, duration: 1))
  }
  
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {menu.doWhenTouchesBegan(touchLocation)}
      if deathMenu.isActive {deathMenu.doWhenTouchesBegan(touchLocation)}
      if slingshot.canShoot && !menu.wasPressed && !deathMenu.wasPressed {
        ball.physicsBody?.resting = true
        slingshot.aim(ball, atPoint: touchLocation)
      }
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
    
    var shot = Bool(false)
    if !menu.wasPressed && !deathMenu.wasPressed {shot = slingshot.shoot(terrains.current, ball: ball)}
    
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {
        menu.doWhenTouchesEnded(touchLocation, shot: shot)
      }
      if deathMenu.isActive {
        deathMenu.doWhenTouchesEnded(touchLocation, shot: shot)
      }
      
      if touch.tapCount == 2 {
        doubleTapped()
      }
    }
    
    if touches.count == 2 {
      twoFingerTapped()
    }
    
    if shot && score.box.alpha < 0.5 {score.appear()}
  }
  
  
  func twoFingerTapped() {
    AdToAppSDK.showInterstitial(ADTOAPP_INTERSTITIAL)
  }
  
  func doubleTapped() {
    let defaults = NSUserDefaults()
    defaults.setInteger(defaults.integerForKey("theme") + 1 < themes.count ? defaults.integerForKey("theme") + 1 : 0, forKey: "theme")
  }
  
  
  private func scroll(interval: CGFloat) {
    if menu.isActive {menu.disappear(); score.appear()}
    if deathMenu.isActive {deathMenu.disappear(); score.appear()}
    currentTheme.background.scroll(interval)
    terrains.scroll(interval, progress: verticalProgress, ball: ball, score: score)
    ball.scroll(interval)
    slingshot.scroll(interval, ball: ball)
    
    verticalProgress += interval
  }
  
  override func update(currentTime: CFTimeInterval) {
    if ball.position.y < 0 {reset()}
    let interval = ball.position.y - frame.height*scrollThresholdOnScreen
    if interval > 0 {scroll(interval)}
    ball.update(terrains)
    slingshot.update(terrains.current, ball: ball)
  }
  
  
  func getScreenShot() -> UIImage {
    let bounds = UIScreen.mainScreen().bounds
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    self.view!.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return img
    
  }
  
  
  func didBeginContact(contact: SKPhysicsContact) {
    if contact.collisionImpulse > 0.45 && defaults.boolForKey("SFX") {
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
    let path = NSBundle.mainBundle().pathForResource("StrangeGreenPlanet.mp3", ofType:nil)!
    let url = NSURL(fileURLWithPath: path)
    
    do {
      let sound = try AVAudioPlayer(contentsOfURL: url)
      backgroundMusicPlayer = sound
      backgroundMusicPlayer.numberOfLoops = -1
      backgroundMusicPlayer.prepareToPlay()
      backgroundMusicPlayer.play()
    } catch {
      fatalError("couldn't load music file")
    }
    
    backgroundMusicPlayer.volume = defaults.boolForKey("Music") ? 0.24 : 0
  }
  
  
  func buildBounceSound() {
    let path = NSBundle.mainBundle().pathForResource("Bounce.mp3", ofType:nil)!
    let url = NSURL(fileURLWithPath: path)
    for _ in 0...2 {
      do {
        let sound = try AVAudioPlayer(contentsOfURL: url)
        sound.prepareToPlay()
        bounceSoundPlayer.append(sound)
      } catch {
        fatalError("couldn't load music file")
      }
    }
  }
  
  
  func playBounceSound(volume: CGFloat) {
    let previousIndex = bouncePlayerIndex - 1 >= 0 ? bouncePlayerIndex - 1 : 2
    if bounceSoundPlayer[previousIndex].playing {
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
  
  
  func setupSound() {
    beginBgMusic()
    buildBounceSound()
  }
  
  
  func setupAdToApp() {
    if adsOn {
      AdToAppSDK.startWithAppId(
        "39c3f1a3-bced-4ae4-851b-7cb603a44479:c4050a11-a7eb-4733-b961-7d77c7601aee",
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
    
    AdToAppView.attachToView(view, position: ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets: UIEdgeInsetsZero, bannerSize: ADTOAPPSDK_BANNER_SIZE_320x50, delegate: self)
    let banner:AdToAppView = AdToAppView.attachToView(self.view, position:ADTOAPPSDK_BANNER_POSITION_BOTTOM, edgeInsets:UIEdgeInsetsZero, bannerSize:ADTOAPPSDK_BANNER_SIZE_320x50, delegate:self) as! AdToAppView
    banner.setRefreshInterval(25.0)
    
    showAdPlaceholder()
  }
  
  func adToAppViewDidDisplayAd(_: AdToAppView!, providerId: Int32) {
    return
  }
  
  func showAdPlaceholder() {
    if !atpPlaceholderActive && adsOn {
      let adPlaceholder = SKSpriteNode(imageNamed: "adPlaceholder")
      adPlaceholder.position = CGPointMake(frame.midX, adPlaceholder.frame.height/2)
      addChild(adPlaceholder)
      atpPlaceholderActive = true
    }
  }
  
  func adToAppView(adToAppView: AdToAppView!, failedToDisplayAdWithError error: NSError!, isConnectionError: Bool) {
    return
  }
  
  func onAdWillAppear(adType: String, providerId: Int32) {
    NSLog("On interstitial show")
  }
  
  func onAdDidDisappear(adType: String, providerId: Int32) {
    NSLog("On interstitial hide")
  }
  
  //optional
  func onReward(reward: Int32, currency gameCurrency: String!, providerId: Int32) {
    NSLog("On reward")
  }
  
  //optional
  func shouldShowAd(adType: String)-> Bool {
    NSLog("On shoud show Ad")
    
    return true;
  }
  
  //optional
  func onAdClicked(adType: String!, providerId: Int32) {
    NSLog("On Ad clicked")
  }
  
  //optional
  func onAdFailedToAppear(adType: String!) {
    NSLog("On Ad failed to appear")
  }
  
  //optional
  func onFirstAdLoaded(adType: String!) {
    NSLog("On First Ad Loaded")
  }
  
}
