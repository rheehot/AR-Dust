# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ARDust' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ARDust
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxAppState'
  pod 'RxDataSources'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftLint'

  target 'ARDustTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ARDustUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  # Pods for Image & Ui
  pod 'Kingfisher'
  pod 'Hero'

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'RxBlocking'
  pod 'RxTest'
end

inhibit_all_warnings! 
end
