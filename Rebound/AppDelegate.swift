//
//  AppDelegate.swift
//  Rebound
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 oakl.in. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdToAppSDKDelegate, AdToAppViewDelegate {
  
  var window: UIWindow?
  
  override class func initialize() -> Void {
    
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    iRate.sharedInstance().applicationBundleID = "com.charcoaldesign.rainbowblocks-free"
    iRate.sharedInstance().onlyPromptIfLatestVersion = false
    
    //enable preview mode
    iRate.sharedInstance().previewMode = true
    
  }
  
  func adToAppViewDidDisplayAd(adToAppView: AdToAppView!, providerId: Int32) {
    return
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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    AdToAppSDK.enableDebugLogs()
//    AdToAppSDK.enableTestMode()
    
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
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

