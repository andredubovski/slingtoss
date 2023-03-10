//
//  AppDelegate.swift
//  SlingToss
//
//  Created by Andre Oaklin on 8/7/16.
//  Copyright © 2016 witehat.com. All rights reserved.
//

import iRate
import UIKit
import SwiftyStoreKit
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  override class func initialize() -> Void {
    
    
    iRate.sharedInstance().usesUntilPrompt = 3
    iRate.sharedInstance().daysUntilPrompt = 1
    iRate.sharedInstance().remindPeriod = 3
    iRate.sharedInstance().messageTitle = "PLEASE RATE!"
    iRate.sharedInstance().message = "Please say nice things about my app."
    iRate.sharedInstance().rateButtonLabel = "Yea sure 😎"
    iRate.sharedInstance().remindButtonLabel = "Later"
    iRate.sharedInstance().cancelButtonLabel = "Nah, I suck"
//    iRate.sharedInstance().declinedThisVersion = false
//    iRate.sharedInstance().declinedAnyVersion = false
//    iRate.sharedInstance().ratedThisVersion = false
//    iRate.sharedInstance().ratedAnyVersion = false
    iRate.sharedInstance().onlyPromptIfLatestVersion = false
    
  }
  
  
  @nonobjc func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    SwiftyStoreKit.completeTransactions(atomically: true) { products in
      
      for product in products {
        
        if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
          
          if product.needsFinishTransaction {
            defaults.set(false, forKey: "Ads")
            gameScene.ataBanner.isHidden = true
            SwiftyStoreKit.finishTransaction(product.transaction)
          }
          print("purchased: \(product)")
        }
      }
    }
    
    SwiftyStoreKit.verifyReceipt(password: "f76006aae37d48e5b4e31f9da3630828") { result in
      switch result {
      case .success(let receipt):
        print("\(receipt)")
      case .error(let error):
        if case .noReceiptData = error {
          SwiftyStoreKit.refreshReceipt { result in }
        }
      }
    }
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}

