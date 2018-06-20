//
//  defs.swift
//

import Foundation
import UIKit

public struct App {
    //let dl: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
    public static let dl = UIApplication.shared.delegate
    public static let DocumentDir: String =  NSHomeDirectory().appendingFormat("/%@/", "Documents")
    public static let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    public static let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    public static let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
    public static let TouchHeightDefault = 44
    public static let TouchHeightSmall = 32
    public static let IS_IOS7: Bool = (Float(UIDevice.current.systemVersion)! >= 7.0) && (Float(UIDevice.current.systemVersion)! < 8.0)
    public static let IS_IOS8: Bool = (Float(UIDevice.current.systemVersion)! >= 8.0) && (Float(UIDevice.current.systemVersion)! < 9.0)
    public static let IS_IOS9: Bool = (Float(UIDevice.current.systemVersion)! >= 9.0) && (Float(UIDevice.current.systemVersion)! < 10.0)
    public static let IS_IOS10: Bool = (Float(UIDevice.current.systemVersion)! >= 10.0) && (Float(UIDevice.current.systemVersion)! < 11.0)
    public static let IS_IOS11: Bool = (Float(UIDevice.current.systemVersion)! >= 11.0) && (Float(UIDevice.current.systemVersion)! < 12.0)
    public static let IS_IPAD: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    public static let IS_IPHONE: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
    public static let IS_RETINA: Bool = UIScreen.main.scale >= 2.0
    public static let DeviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: ""))!
}

public struct Util {
    //
    public static let ShortcutFile: [String] = ["lnk"]
    public static let TextFile: [String] = ["txt","log","html","php","js","hpp","h","cpp","c","m","ini","bat"]
    public static let ExcelFile: [String] = ["xls","xlt","xlm","xlsx","xlsm","xltx","xltm","xlsb","xla","xlam","xll","xlw"]
    public static let WordFile: [String] = ["doc","dot","docx","docm","dotx","dotm","docb","rtf"]
    public static let PowerPointFile: [String] = ["ppt","pot","pps","pptx","pptm","potx","potm","ppam","ppsx","ppsm","sldx","sldm"]
    public static let GifFile: [String] = ["gif"]
    public static let PngFile: [String] = ["png","bmp"]
    public static let JpegFile: [String] = ["jpg","jpeg"]
    public static let PdfFile: [String] = ["pdf"]
    public static let CsvFile: [String] = ["csv"]
    public static let VideoFile: [String] = ["mp4","mov"]
    public static let SupportFiles: [[String]] = [ShortcutFile,TextFile,ExcelFile,WordFile,PowerPointFile,GifFile,PngFile,JpegFile,PdfFile,CsvFile,VideoFile]

    //
    public static func ShowNetworkActivityIndicator() -> Void { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
    public static func HideNetworkActivityIndicator() -> Void { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
    public static func NetworkActivityIndicatorVisible(x:Bool) -> Void { UIApplication.shared.isNetworkActivityIndicatorVisible = x }
    public static func NotifyKeyboard(showSelector: Selector, hideSelector: Selector, target: Any) -> Void {
        NotificationCenter.default.addObserver(target, selector: showSelector, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(target, selector: hideSelector, name: .UIKeyboardWillHide, object: nil)
    }
    public static func NotifyDeviceOrientation(changeSelector: Selector, target: Any) -> Void {
        NotificationCenter.default.addObserver(target, selector: changeSelector, name: .UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    public static func textSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let maxSize: CGSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let attr: Dictionary = [NSAttributedStringKey.font: font]
        let modifiedSize: CGSize = ((text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: attr, context: nil)).size
        return modifiedSize
    }
    public static func textHeight(text: String, font: UIFont, maxWidth: CGFloat, heightOffset: Float, minHeight: Float) -> Float {
        let maxSize: CGSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let attr: Dictionary = [NSAttributedStringKey.font: font]
        let modifiedSize: CGSize = ((text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: attr, context: nil)).size
        return max(ceilf(Float(modifiedSize.height)) + heightOffset, minHeight)
    }
    public static func supportFile(fileName: String) -> Bool {
        for fileTypes in SupportFiles {
            for str in fileTypes {
                if (fileName as NSString).pathExtension.lowercased() == str {
                    return true
                }
            }
        }
        return false
    }
    public static func isFileType(fileName: String, fileTypes: [String]) -> Bool {
        for str in fileTypes {
            if (fileName as NSString).pathExtension.lowercased() == str {
                return true
            }
        }
        return false
    }
    public static func shortcutFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: ShortcutFile)
    }
    public static func gifFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: GifFile)
    }
    public static func pngFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: PngFile)
    }
    public static func jpegFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: JpegFile)
    }
    public static func pdfFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: PdfFile)
    }
    public static func csvFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: CsvFile)
    }
    public static func textFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: TextFile)
    }
    public static func excelFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: ExcelFile)
    }
    public static func powerPointFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: PowerPointFile)
    }
    public static func videoFile(fileName: String) -> Bool {
        return isFileType(fileName: fileName, fileTypes: VideoFile)
    }
    
    //
    public static var platformType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        if platform=="iPhone1,1" {return "iPhone 2G"}
        if platform=="iPhone1,2" {return "iPhone 3G"}
        if platform=="iPhone2,1" {return "iPhone 3GS"}
        if platform=="iPhone3,1" {return "iPhone 4"}
        if platform=="iPhone3,2" {return "iPhone 4"}
        if platform=="iPhone3,3" {return "iPhone 4"}
        if platform=="iPhone4,1" {return "iPhone 4S"}
        if platform=="iPhone5,1" {return "iPhone 5"}
        if platform=="iPhone5,2" {return "iPhone 5 (GSM+CDMA)"}
        if platform=="iPhone5,3" {return "iPhone 5c (GSM)"}
        if platform=="iPhone5,4" {return "iPhone 5c (GSM+CDMA)"}
        if platform=="iPhone6,1" {return "iPhone 5s (GSM)"}
        if platform=="iPhone6,2" {return "iPhone 5s (GSM+CDMA)"}
        if platform=="iPhone8,4" {return "iPhone SE"}
        if platform=="iPhone7,1" {return "iPhone 6 Plus"}
        if platform=="iPhone7,2" {return "iPhone 6"}
        if platform=="iPhone8,2" {return "iPhone 6s Plus"}
        if platform=="iPhone8,1" {return "iPhone 6s"}
        if platform=="iPhone9,1" {return "iPhone 7"}
        if platform=="iPhone9,3" {return "iPhone 7"}
        if platform=="iPhone9,2" {return "iPhone 7 Plus"}
        if platform=="iPhone9,4" {return "iPhone 7 Plus"}
        if platform=="iPhone10,1" {return "iPhone 8"}
        if platform=="iPhone10,4" {return "iPhone 8"}
        if platform=="iPhone10,2" {return "iPhone 8 Plus"}
        if platform=="iPhone10,5" {return "iPhone 8 Plus"}
        if platform=="iPhone10,3" {return "iPhone X"}
        if platform=="iPhone10,6" {return "iPhone X"}
        if platform=="iPod1,1" {return "iPod Touch (1 Gen)"}
        if platform=="iPod2,1" {return "iPod Touch (2 Gen)"}
        if platform=="iPod3,1" {return "iPod Touch (3 Gen)"}
        if platform=="iPod4,1" {return "iPod Touch (4 Gen)"}
        if platform=="iPod5,1" {return "iPod Touch (5 Gen)"}
        if platform=="iPod7,1" {return "iPod Touch (6 Gen)"}
        if platform=="iPad1,1" {return "iPad"}
        if platform=="iPad1,2" {return "iPad 3G"}
        if platform=="iPad2,1" {return "iPad 2 (WiFi)"}
        if platform=="iPad2,2" {return "iPad 2"}
        if platform=="iPad2,3" {return "iPad 2 (CDMA)"}
        if platform=="iPad2,4" {return "iPad 2"}
        if platform=="iPad2,5" {return "iPad Mini (WiFi)"}
        if platform=="iPad2,6" {return "iPad Mini"}
        if platform=="iPad2,7" {return "iPad Mini (GSM+CDMA)"}
        if platform=="iPad3,1" {return "iPad 3 (WiFi)"}
        if platform=="iPad3,2" {return "iPad 3 (GSM+CDMA)"}
        if platform=="iPad3,3" {return "iPad 3"}
        if platform=="iPad3,4" {return "iPad 4 (WiFi)"}
        if platform=="iPad3,5" {return "iPad 4"}
        if platform=="iPad3,6" {return "iPad 4 (GSM+CDMA)"}
        if platform=="iPad4,1" {return "iPad Air (WiFi)"}
        if platform=="iPad4,2" {return "iPad Air (Cellular)"}
        if platform=="iPad4,4" {return "iPad Mini 2 (WiFi)"}
        if platform=="iPad4,5" {return "iPad Mini 2 (Cellular)"}
        if platform=="iPad4,6" {return "iPad Mini 2"}
        if platform=="iPad4,7" {return "iPad Mini 3"}
        if platform=="iPad4,8" {return "iPad Mini 3"}
        if platform=="iPad4,9" {return "iPad Mini 3"}
        if platform=="iPad5,1" {return "iPad Mini 4 (WiFi)"}
        if platform=="iPad5,2" {return "iPad Mini 4 (LTE)"}
        if platform=="iPad5,3" {return "iPad Air 2"}
        if platform=="iPad5,4" {return "iPad Air 2"}
        if platform=="iPad6,3" {return "iPad Pro 9.7"}
        if platform=="iPad6,4" {return "iPad Pro 9.7"}
        if platform=="iPad6,7" {return "iPad Pro 12.9"}
        if platform=="iPad6,8" {return "iPad Pro 12.9"}
        if platform=="iPad6,11" {return "iPad (5th Gen)"}
        if platform=="iPad6,12" {return "iPad (5th Gen)"}
        if platform=="iPad7,1" {return "iPad Pro 12.9 (2nd Gen)"}
        if platform=="iPad7,2" {return "iPad Pro 12.9 (2nd Gen)"}
        if platform=="iPad7,3" {return "iPad Pro 10.5"}
        if platform=="iPad7,4" {return "iPad Pro 10.5"}
        if platform=="AppleTV2,1" {return "Apple TV 2G"}
        if platform=="AppleTV3,1" {return "Apple TV 3"}
        if platform=="AppleTV3,2" {return "Apple TV 3 (2013)"}
        if platform=="i386" {return "Simulator"}
        if platform=="x86_64" {return "Simulator"}
        return "Unknown Platform"
    }
}

//
public func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0) }
public func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
