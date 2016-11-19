
## 47.15 (November 7, 2016)

UPDATED:
- Vungle to 4.0.8;

## 47.14 (November 1, 2016)

UPDATED:
- Supersonic to 6.4.18;
- MyTarget to 4.5.14;
- iSoma to 8.0.10;
- GoogleMobileAds to 7.14.0;
- Facebook to 4.17.0;

## 47.13 (October 24, 2016)

UPDATED:
- Instreamatic to 2.9.4;
- GoogleMobileAds to 7.13.1;
- Yandex to 2.5.0 (Yandex Metrica to 2.6.2);

REMOVED:
- Chartboost provider;

## 47.12 (October 17, 2016)

UPDATED:
- Vungle to 4.0.6;
- MyTarget to 4.5.12;
- iSoma to 8.0.9;

## 47.11 (October 11, 2016)

UPDATED:
- GoogleMobileAds to 7.12.1;
- RevMobAds to 9.2.3;
- Instreamatic to 2.9.3;
- FlurryAds to 7.8.0;
- Facebook to 4.16.1;

## 47.10 (October 3, 2016)

UPDATED:
- AmazonAd to 2.2.15;
- Vungle to 4.0.5;
- TapSense to 3.2.3;
- Supersonic to 6.4.17;
- NativeX to 5.5.9;
- RevMobAds to 9.2.2;
- InMobi to 6.0.0;
- MyTarget to 4.5.9;
- iSoma to 8.0.8;
- GoogleMobileAds to 7.12.0;
- Yandex to 2.4.0 (Yandex Metrica to 2.6.0);
- Facebook to 4.16.0;

- RevMob provider become optional (removed from full version of AdToAppSDK because of the large number of crashes);

## 47.9 (September 26, 2016)

UPDATED:
- Wooby provider (Image);
- Supersonic provider with SDK v6.4.17;

## 47.8 (September 26, 2016)

ADDED:
- Facebook provider (Interstitial and Banners formats);
- NativeX provider with SDK v5.5.8;

## 47.7 (September 19, 2016)

FIXED:
- analytics uploader bugfixes;

## 47.6 (September 15, 2016)

REMOVED:
- NativeX provider

## 47.5 (September 14, 2016)

UPDATED:
- installs tracking logic for InHouse ads;

## 47.4 (September 6, 2016)

UPDATED:
- GoogleMobileAds to 7.10.1;

## 47.3 (September 5, 2016)

UPDATED:
- miscellaneous improvements in "Show Interstitial" logic;

## 47.2 (August 30, 2016)

FIXED:
- InHouse impression tracking;
- InHouse module disabling;

## 47.1 (August 26, 2016)

ADDED:
- FlurryAds provider (Interstitial, Image, Video, Reward);

## 47.0 (August 25, 2016)

ADDED:
- InHouse ads;
- Wooby provider (Interstitial);

UPDATED:
- miscellaneous improvements;

## 46.31 (August 22, 2016)

ADDED:
- InHouse ads (optional, in chunks version of SDK);

## 46.30 (August 15, 2016)

ADDED:
- RevMob provider (Interstitial, Image, Video, Reward, Banner);

## 46.29 (August 11, 2016)

ADDED:
- StartApp rewarded ads;

## 46.28 (August 9, 2016)

UPDATED:
- AdColony to 2.6.2;
- Vungle to 3.2.2;
- Supersonic to 6.4.11;
- NativeX to 5.5.7.1;
- MyTarget to 4.5.3;
- StartApp to 3.3.5;

## 46.27 (August 4, 2016)

ADDED:
- Instreamatic 2.9.1 (Interstitial);

## 46.26 (August 3, 2016)

UPDATED:
- Yandex to 2.3.0;

- miscellaneous improvements;

## 46.25 (July 28, 2016)

FIXED:
- crash in iOS7

## 46.24 (July 12, 2016)

UPDATED:
added 'providerId' as return parameter to AdToAppViewDelegate methods:

-(void)adToAppViewDidDisplayAd:(AdToAppView*)adToAppView providerId:(int)providerId;
-(void)adToAppViewOnClick:(AdToAppView*)view providerId:(int)providerId;

List of providers available at AdToAppSDK header file;

## 46.23 (July 11, 2016)

UPDATED:
added 'providerId' as return parameter to AdToAppSDKDelegate methods:

-(void)onAdWillAppear:(NSString*)adType providerId:(int)providerId;
-(void)onAdDidDisappear:(NSString*)adType providerId:(int)providerId;
-(void)onReward:(int)reward currency:(NSString*)gameCurrency providerId:(int)providerId;
-(void)onAdClicked:(NSString*)adType providerId:(int)providerId;

List of providers available at AdToAppSDK header file;

## 46.22 (July 7, 2016)

FIXED:
- MyTarget rewarded ads (Bug was in additional reward on video replay);

## 46.21 (June 29, 2016)

ADDED:
- Personagraph - 2.4.5-b1;

## 46.20 (June 23, 2016)

FIXED:
- minor bug fixes;

ADDED:
- Avocarrot provider (INTERSTITIAL and IMAGE);
- NativeX provider (IMAGE, VIDEO and REWARD);

## 46.19 (June 21, 2016)

FIXED:
- caching queue logic (There was a bug where caching queue could stops caching on Smaato provider even though there are more providers in queue after Smaato);

## 46.18 (June 21, 2016)

UPDATED:
- miscellaneous improvements;

REMOVED:
- MoPub provider;

## 46.17 (June 16, 2016)

UPDATED:
- Chartboost to 6.4.4;
- Vungle to 3.2.1;
- Supersonic to 6.4.7;
- Yandex to 2.1.2;
- Applovin to 3.3.1;
- InMobi to 5.3.1;
- MyTarget to 4.4.7;
- StartApp to 3.3.3;

## 46.16 (June 8, 2016)

FIXED:
- now interstitial Test Ads is visible on all types of iOS devices;

ADDED:
- NativeX provider;

## 46.15 (June 1, 2016)

ADDED:
- bitcode support in chunks version of SDK (read integration instruction to find out how enable bitcode in your project and which providers support it);

UPDATED:
- GoogleMobileAds to 7.8.1;

## 46.14 (May 24, 2016)

ADDED:
- current reward amount and currency can be easily obtained at any time;

## 46.13 (May 13, 2016)

UPDATED:
- banner reloading algorithm;

## 46.12 (May 5, 2016)

ADDED:
- Yandex 2.1.1 (optional, in chunks version of SDK or via Cocoapods subspec AdToApp/Yandex);

UPDATED:
- MyTarget banner refresh logic;

## 46.11 (May 4, 2016)

UPDATED:
- banner reloading algorithm

## 46.10 (April 29, 2016)

FIXED:
- small bug fixes and improvements;

ADDED:
- Supersonic 6.4.3 (Interstitial, Image, Reward);

## 46.9 (April 22, 2016)

FIXED:
- crash when loaded banner from Smaato provider if |AppDelegate| doesn't contain |window| property;

UPDATED:
- Cocoapods specification. Added subspecs for loading specific providers or modules (Interstitial,Reward etc.)

## 46.8 (April 18, 2016)

REMOVED:
- Personagraph SDK;

## 46.7 (April 15, 2016)

UPDATED:
- mediation algorithm improvements;

- AmazonAd to 2.2.14;
- Chartboost to 6.4.2;
- GoogleMobileAds to 7.7.1;
- StartApp to 3.3.2;
- InMobi to 5.3.0;
- MoPub to 4.5.1;
- MyTarget to 4.4.5;
- Personagraph to 2.4.5-b1.

FIXED:
- InMobi banner on click callback;
- MyTaget delegate methods. Delegate methods may not be invoked in cases when MyTarget interstitial ad is displayed for long time on screen.

## 46.6 (April 12, 2016)

FIXED:
- server logs for Smaato and TapSense providers

## 46.5 (April 7, 2016)

UPDATED:
- caching algorithm for AppLovin provider

## 46.4 (April 7, 2016)

FIXED:
- excessive loading of Applovin ads

## 46.3 (April 6, 2016)

ADDED:
- Logs and alerts for critical errors.

## 46.2 (March 25, 2016)

ADDED:
- Video and Rewarded ads for MyTarget provider

## 46.1 (March 24, 2016)

UPDATED:
- banner refresh algorithm: unnecessary retries removed

ADDED:
- log sessions

UPDATED:
- AdMob to 7.7.0;
- InMobi to 5.2.1;

FIXED:
- IDFA not sent with server debug logs

## 46.0 (March 11, 2016)

ADDED:
- new APIs to enable user and context metadata targeting by advertisers.
- ability to modify array of waterfalls on server side

UPDATED:
- stability improvements for ratings request

## 45.40 (March 2, 2016)

UPDATED:
- minor optimizations;

## 45.39 (March 1, 2016)

UPDATED:
- clear credentials cache after SDK start;

## 45.38 (February 29, 2016)

ADDED:
- UncaughtException handling (disabled by default and turn on remotely);
- availability to remotely enable logging;

UPDATED:
- disable banners autoreferesh when application inactive or working in background;

## 45.37 (February 24, 2016)

UPDATED:
- stability improvements

## 45.36 (February 18, 2016)

FIXED:
- crash on startup on devices with invalid cache

## 45.35 (February 16, 2016)

FIXED:
- TapSense provider crashed without internet

## 45.34 (February 15, 2016)

UPDATED:
- compatibility with native ads SDK.

## 45.33 (February 12, 2016)

ADDED:
- added server side targeting (keywords,gender,age) support.

FIXED:
- fixed InMobi caching logic. In rare cases secondary cached InMobi ad may break currently visible InMobi ad.

UPDATED:
- enabled test mode by default on Simulator for Amazon, AdMob, MoPub providers.

## 45.32 (February 4, 2016)

REMOVED:
- Personagraph is disabled for iOS ver < 9.0
- removed support for iOS6

## 45.31 (January 28, 2016)

UPDATED:
- AdColony to 2.6.1;
- Chartboost to 6.2.1;
- StartApp to 3.3.0;
- UnityAds to 1.5.6;
- Applovin to 3.2.2;
- InMobi to 5.2.0;
- MyTarget to 4.3.0;
- Smaato to 8.0.4;
- MoPub to 4.3.0;

## 45.30 (January 26, 2016)

FIXED:
- some bunners could be zero frame because placements could miss few sizes;

UPDATED:
- AmazonAd to 2.2.13;

ADDED:
- InMobi rewarded ads;

## 45.29 (January 19, 2016)

FIXED:
- showing interstitial can be initiated when interstitial is already being shown

## 45.28 (December 24, 2015)

IMPROVEMENT:
- improved SDK logging system;

## 45.27 (December 17, 2015)

UPDATED:
- Applovin SDK to 3.2.1;
- Unity SDK to 1.5.4;
- AdMob SDK to 7.6.0;
- updated TEST provider ID from 65536 to 32767;

FIXED:
- fixed AdToAppView adIsDisplayed flag. Sometimes it could show false when banner is visible;
- fixed AdToAppView banners autorefresh logic. Some banners were auto reloaded even autorefresh was disabled;
- fixed AdMob banners display issue. Banner could be loaded but displayed below previous banner;

## 45.26 (December 14, 2015)

FIXED:
- downgraded AppLovin to v3.1.5 because of issue in AppLovin callback logic;

## 45.25 (December 10, 2015)

ADDED:
- added new callback for interstitial ads "onFirstAdLoaded:"

## 45.24 (December 7, 2015)

UPDATED:
- synchronized with Chartboost 6.1.1;
- synchronized with TapSense 3.2.2;
- synchronized with Applovin 3.1.6;
- synchronized with MyTarget 4.2.4;
- changed visibility for Error UIAlertView. Now they appearing only for simulator.
- not specified App Transport Security (ATS) is not preventing from start SDK

FIXED:
- fixed minor bugs in logging;

## 45.23 (November 30, 2015)

UPDATED:
- synchronized with Smaato 8.0.0;

FIXED:
- fixed "onAdWillAppear:" callback for Smaato provider interstitial ads;

## 45.22 (November 24, 2015)

FIXED:
- fixed Amazon and StartApp compile errors for chunk version of AdToAppSDK (occurs when AmazonAds or StartApp libs is excluded);

## 45.21 (November 20, 2015)

FIXED:
- fixed Video Ads displaying on method call showInterstitial:ADTOAPP_IMAGE_INTERSTITIAL (Chartboost and StartApp);

REMOVED:
- removed support for AppNext and Revmob providers;

## 45.20 (November 19, 2015)

UPDATED:
- improved Providers banner load logic (728x90 banner will be loaded if 768x90 not available);

## 45.19 (November 18, 2015)

UPDATED:
- improved Banners mediation logic;

FIXED:
- fixed (hasInterstitial:) method. (Allways return YES if Smaato provider enabled or NO if not enabled);

## 45.18 (November 17, 2015)

ADDED:
- AdToApp Analytics uploader;

## 45.17 (November 16, 2015)

UPDATED:
- synchronized with InMobi 5.0.2;
- updated SwiftDemo project;

## 45.16 (November 10, 2015)

ADDED:
- Personagraph SDK v2.4.2-b2;

## 45.15 (November 5, 2015)

UPDATED:
- synchronized with UnityAds 1.5.3;

## 45.14 (November 2, 2015)

ADDED:
- new provider "TapSense" with support of Interstitial (Image, Video) and Banners (320x50; 728x90; 300x250);

UPDATED:
- synchronized with StartApp 3.2.3;

## 45.13 (October 27, 2015)

FIXED:
- StartApp banner alignment

## 45.12 (October 26, 2015)

ADDED:
- console debug logs

## 45.11 (October 26, 2015)

FIXED:
- rewarded ads for applovin

## 45.10 (October 22, 2015)

ADDED:
- additional logs to upload

## 45.9

FIXED:
- AppStore submission ERROR "Invalid CFBundleSupportedPlatform value. ... /UnityAds.bundle' contains an invalid value '("iPhoneSimulator")' ..."

UPDATED:
- synchronized with AdMob 7.5.2;
- synchronized with StartApp 3.2.2;
- synchronized with Applovin 3.1.5;
- synchronized with Avocarrot 151013;

## 45.6

DELETED:
- caching for Smaato provider

## 45.5

UPDATED:
- logging in showInterstitial

## 45.4 (October 8, 2015)

ADDED:
- analytic logs

## 45.3 (October 7, 2015)

FIXED:
- logs for 'caching not yet finished' error

## 45.2 (October 6, 2015)

FIXED:
- fixed setup providers issue, when no one of the available providers initialized on credentials response (Setting strong reference to providers in full nativ AdToAppSDK)

## 45.1 (October 5, 2015)

ADDED:
- logging of Show and Hide events for Interstitials
- logging of banner events

FIXED:
- caching is stopped in case of multiple errors

UPDATED:
- cached interstitial check interval 1.1 min -> 45 sec

## 45 (September 22, 2015)

UPDATED:
- verification of resources added

## 44 (September 17, 2015)

UPDATED:
- comments in header files

ADDED:
- ADTOAPP_NATIVE constant in header file
- minor stability improvements

## 43 (September 16, 2015)

DELETED:
- Leadbolt provider;

## 42 (September 15, 2015)

UPDATED:
- Applovin to 3.1.2;
- AmazonAd to 2.2.10;
- UnityAds to 1.5.1;
- MoPub to 3.12.0.

## 41 (September 9, 2015)

ADDED:
- optimization: IMAGE module is enabled automatically if INTERSTITIAL module is enabled.

## 40 (September 4, 2015)

UPDATED:
- Smaato provider library;

## 39 (September 1, 2015)

FIXED:
- fixed credentials setup for Smaato interstitials and banners;


## 38 (August 31, 2015)

FIXED:
- fixed problems with displaying MoPub full screen banners (Interstitials).
(replaced MPAdBrowserController.xib with MPAdBrowserController.nib in MoPub.bundle)


## 37 (August 27, 2015)

ADDED:
- Test Interstitials ads now react on Orientation Changed events;

FIXED:
- fixed layout of Test Interstitial banners for iOS7 and older;

UNAVAILABLE:
- removed support for banners with size 1024x90;


## 36 (August 21, 2015)

UPDATED:
- updated providers libraries;

FIXED:
- fixed bugs in the logs;
- fixed layout of test interstitial banners;


