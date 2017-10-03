# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
  use_frameworks!

def shared_pods
  pod 'PiwikTracker', git: 'https://github.com/piwik/piwik-sdk-ios.git', branch: 'master'
  pod 'ObjectMapper'
  pod 'Alamofire'
end

target 'TJUBBS' do
  shared_pods
  pod 'SnapKit'
  pod 'PKHUD', '~> 4.0'
  pod 'MJRefresh', '~> 3.1.12'
  pod 'WMPageController', '2.3.0'
  pod 'SlackTextViewController'
  pod 'AsyncDisplayKit'
  pod 'Kingfisher'
  pod 'DTCoreText'
  pod 'Marklight'
  pod 'YYText'
  pod 'TOCropViewController'
  #pod 'PiwikTracker', '~> 4.0.0-beta'
end

target 'BBSWidget' do
	shared_pods
end
