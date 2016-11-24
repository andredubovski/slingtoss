platform :ios, '9.0'
target 'SlingToss' do
  
  pod 'iRate'
  
  pod 'AdToApp'
  pod 'AdToApp/Interstitial'
  pod 'AdToApp/Image'
  pod 'AdToApp/Video'
  pod 'AdToApp/Banner'
  
#  pod 'AdToApp/AdColony'
#  pod 'AdToApp/AmazonAd'
#  pod 'AdToApp/Applovin'
#  pod 'AdToApp/AdMob'
#  pod 'AdToApp/InMobi'
#  pod 'AdToApp/MyTarget'
#  pod 'AdToApp/Smaato'
#  pod 'AdToApp/StartApp'
#  pod 'AdToApp/TapSense'
#  pod 'AdToApp/Unity'
#  pod 'AdToApp/Vungle'
#  pod 'AdToApp/Supersonic'
#  pod 'AdToApp/NativeX'
#  pod 'AdToApp/Avocarrot'
#  pod 'AdToApp/Instreamatic'
#  pod 'AdToApp/Revmob'
#  pod 'AdToApp/Flurry'
#  pod 'AdToApp/Inhouse'
#  pod 'AdToApp/Yandex'
  
  use_frameworks!
  pod 'SwiftyStoreKit'
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
