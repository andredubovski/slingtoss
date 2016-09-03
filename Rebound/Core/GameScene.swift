//
//  GameScene.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright (c) 2016 oakl.in. All rights reserved.
//

import SpriteKit

var gameFrame = CGRect()
let blankView = UIView()

class GameScene: SKScene, AdToAppSDKDelegate, AdToAppViewDelegate {
  
  var isVirgin = Bool(true)
  var menu = MainMenu()
  var deathMenu = DeathMenu()
  let terrains = TerrainController()
  let ball = Ball()
  let slingshot = Slingshot()
  let score = Score()
  
  let scrollThresholdOnScreen = CGFloat(0.36)
  var verticalProgress = CGFloat(0)
  
  var atpView = AdToAppView()
  var atpActive = Bool(true)
  var atpPlaceholderActive = Bool(false)
  
  var backgroundMusic = SKAudioNode()
  
  override func didMoveToView(view: SKView) {
    print("did move to view")
    if isVirgin {gameSetup(); isVirgin = false}
    
    let doubleTwoFingerTap = UITapGestureRecognizer(target: self, action: #selector(doubleTwoFingerTapped))
    doubleTwoFingerTap.numberOfTapsRequired = 2
    doubleTwoFingerTap.numberOfTouchesRequired = 2
    view.addGestureRecognizer(doubleTwoFingerTap)
    
    let twoFingerTap = UITapGestureRecognizer(target: self, action: #selector(twoFingerTapped))
    twoFingerTap.numberOfTapsRequired = 1
    twoFingerTap.numberOfTouchesRequired = 2
    twoFingerTap.requireGestureRecognizerToFail(doubleTwoFingerTap)
    view.addGestureRecognizer(twoFingerTap)
    
    let tripleTap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
    tripleTap.numberOfTapsRequired = 3
    view.addGestureRecognizer(tripleTap)
    
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.requireGestureRecognizerToFail(tripleTap)
    view.addGestureRecognizer(doubleTap)
  }
  
  private func gameSetup() {
    
    currentTheme.build()
    setupAdToApp()
    playBackgroundMusic("MyGlowingGeometry.m4a")
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
    
  }
  
  func buildWalls() {
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
    
    terrains.reset(ball, menu: menu.isActive ? menu:deathMenu)
    ball.reset()
    
    scroll()
    deathMenu.appear(score.amount)
    score.reset()
    
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
    if !menu.wasPressed && !deathMenu.wasPressed {shot = slingshot.shoot(ball)}
    
    for touch in touches {
      let touchLocation = touch.locationInNode(self)
      if menu.isActive {
        menu.doWhenTouchesEnded(touchLocation, shot: shot)
      }
      if deathMenu.isActive {
        deathMenu.doWhenTouchesEnded(touchLocation, shot: shot)
      }
    }
    
    if shot && score.box.alpha < 0.5 {score.appear()}
  }
  
  
  func twoFingerTapped() {
    print("twoFingerTapped")
    AdToAppSDK.showInterstitial(ADTOAPP_INTERSTITIAL)
  }
  
  func doubleTapped() {
    print("doubleTapped")
    let defaults = NSUserDefaults()
    defaults.setInteger(defaults.integerForKey("theme") + 1 < themes.count ? defaults.integerForKey("theme") + 1 : 0, forKey: "theme")
  }
  
  func doubleTwoFingerTapped() {
    print("doubleTwoFingerTapped")
  }
  
  func tripleTapped() {
    print("tripleTapped")
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
    currentTheme.background.scroll(interval)
    terrains.scroll(interval, progress: verticalProgress, ball: ball, score: score)
    ball.scroll(interval)
    slingshot.scroll(interval, ball: ball)
    
    verticalProgress += interval
  }
  
  override func update(currentTime: CFTimeInterval) {
    if ball.position.y > frame.height*scrollThresholdOnScreen {scroll()}
    ball.update(terrains)
    slingshot.update(ball)
    if ball.position.y < 0 {reset()}
  }
  
  func playBackgroundMusic(fileNamed: String) {
//    runAction(
//      SKAction.repeatActionForever(SKAction.sequence([
//      SKAction.playSoundFileNamed(fileNamed, waitForCompletion: false),
//      SKAction.waitForDuration(90)
//    ])), withKey: "play background music")
    
    backgroundMusic = SKAudioNode(fileNamed: fileNamed)
    addChild(backgroundMusic)
  }
  
  func setupAdToApp() {
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
  
  func adToAppViewDidDisplayAd(_:AdToAppView!, providerId: Int32) {
    return
  }
  
  func showAdPlaceholder() {
    if !atpPlaceholderActive {
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
