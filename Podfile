use_frameworks!
platform :ios, '8.0'
pod 'Crashlytics', '~> 3.4'
pod 'KeychainSwift', '~> 3.0'
pod "PromiseKit", "~> 3.1.1"
pod 'Alamofire', '~> 3.0'
pod 'ObjectMapper', '~> 1.1'
pod 'Eureka', '~> 1.5'
pod 'SwiftValidator', '3.0.3' 
pod "PKHUD"
pod 'IDZSwiftCommonCrypto'
pod 'couchbase-lite-ios'
pod 'ResearchKit', "1.3.0"
pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'
pod 'EmitterKit', '~> 4.0'
pod 'PermissionScope'
pod 'Hakuba'
pod 'XLActionController'
pod 'XCGLogger', '~> 3.3'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    next unless (target.name == 'PromiseKit')
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end
  end
end
