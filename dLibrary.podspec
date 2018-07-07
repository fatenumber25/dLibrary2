Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "dLibrary2"
  s.version      = "0.0.7"
  s.summary      = "Basic framework"
  s.description  = "This framework contains a basic framework and convenient extensions, functions."
  s.homepage     = "https://github.com/fatenumber25"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "phan"
  # s.social_media_url   = "http://twitter.com/fatenumber2"


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "10.0"
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/fatenumber25/dLibrary2", :tag => "0.0.7" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files = "dLibrary", "dLibrary/**/*.{h,m,swift}"
  s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.resource  = "icon.png"
  s.resources = "dLibrary/Resources/*.bundle"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
 
 
  # ――― Other Frameworks ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency "AsyncSwift"
  s.dependency "Alamofire"
  s.dependency "SwiftyJSON"
  s.dependency "FCAlertView"
  s.dependency "SwiftDate"
  s.dependency "FMDB/SQLCipher"
  s.dependency "MBProgressHUD"
  s.dependency "FontAwesomeKit"
  s.dependency "ChameleonFramework"
  s.dependency "NSData+Base64"
  s.dependency "Colours"
  s.dependency "Reachability"
  s.dependency "MMNumberKeyboard"
  s.dependency "CAPostEditorViewController"
  s.dependency "Cartography"
  s.dependency "AMScrollingNavbar"
  s.dependency "CRRefresh"
  s.dependency "DZNEmptyDataSet"
  s.dependency "INTULocationManager"
  s.dependency "Device"
  s.dependency "SwiftyUserDefaults"
  s.dependency "SwiftReorder"
  s.dependency "SwipeCellKit"
  s.dependency "TouchVisualizer"
  s.dependency "ScrollableGraphView"
  s.dependency "SwiftySound"
  s.dependency "SwiftyBeaver"
  s.dependency "UIFontComplete"
  s.dependency "SwiftIcons"
  s.dependency "ImageViewer"
  s.dependency "UIImageColors"
  s.dependency "RandomColorSwift"
  s.dependency "Toucan"
  s.dependency "ImagePicker"
  s.dependency "SkyFloatingLabelTextField"
  s.dependency "NXDrawKit"
  s.dependency "DKImagePickerController"
  s.dependency "RNNotificationView"
  s.dependency "VACalendar"
  s.dependency "SCLAlertView"

end
