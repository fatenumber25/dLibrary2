//
//  Extentions.swift
//

import Foundation
import UIKit

//最前面のUIViewControllerを取得
//usage: UIApplication.shared.topViewController
//usage: UIApplication.shared.topNavigationController
public extension UIApplication {
    public var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    public var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}

// UINavigationController
public extension UINavigationController {
    public func alwaySmall() {
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }
}

// UIViewController
public extension UIViewController {
    public var NavBar: UINavigationBar { return (self.navigationController?.navigationBar)! }
    public var TabBar: UITabBar { return (self.tabBarController?.tabBar)! }
    public var NavBarHeight: CGFloat { return (self.navigationController?.navigationBar.bounds.size.height)! }
    public var TabBarHeight: CGFloat { return (self.tabBarController?.tabBar.bounds.size.height)! }
}

// UIScrollView
public extension UIScrollView {
    public func fixBehavior() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

// UITableView
public extension UITableView {
    public func noHeader() {
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    public func noFooter() {
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    public func noHeaderFooter() {
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
}

// UIView Extesions
public extension UIView {
    //子Viewを全て削除
    //usage: view.removeAllSubViews()
    public func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    //UIViewのスクショを撮る
    //usage↓
    /*let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    label.text = "Hello"
    label.textAlignment = .center
    label.backgroundColor = .white
    let image = label.screenShot(width: 200)*/
    public func screenShot(width: CGFloat) -> UIImage? {
        let imageBounds = CGRect(x: 0, y: 0, width: width, height: bounds.size.height * (width / bounds.size.width))
        
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)
        
        drawHierarchy(in: imageBounds, afterScreenUpdates: true)
        
        var image: UIImage?
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if let contextImage = contextImage, let cgImage = contextImage.cgImage {
            image = UIImage(
                cgImage: cgImage,
                scale: UIScreen.main.scale,
                orientation: contextImage.imageOrientation
            )
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //ViewをSuperviewと同じ大きさにする
    /*superView.addSubview(view)
    view.fillSuperview()*/
    public func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
    
    //そのViewを持つViewControllerを取得
    //usage: view.viewController
    public var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //FrameAccessor
    public var origin: CGPoint { return self.frame.origin }
    public func setOrigin (newOrigin: CGPoint) {
        var newFrame: CGRect = self.frame
        newFrame.origin = newOrigin
        self.frame = newFrame
    }
    public var size: CGSize { return self.frame.size }
    public func setSize (newSize: CGSize) {
        var newFrame = self.frame
        newFrame.size = newSize
        self.frame = newFrame
    }
    public var x: CGFloat { return self.frame.origin.x }
    public func setX (newX: CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newX
        self.frame = newFrame
    }
    public var y: CGFloat { return self.frame.origin.y }
    public func setY (newY: CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newY
        self.frame = newFrame
    }
    public var width: CGFloat { return self.frame.size.width }
    public func setWidth (newWidth: CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = newWidth
        self.frame = newFrame
    }
    public var height: CGFloat { return self.frame.size.height }
    public func setHeight (newHeight: CGFloat) {
        var newFrame = self.frame
        newFrame.size.height = newHeight
        self.frame = newFrame
    }
    public var bottom: CGFloat { return self.frame.origin.y+self.frame.size.height }
    public func setBottom (newBottom: CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newBottom - self.size.height
        self.frame = newFrame
    }
    public var right: CGFloat { return self.frame.origin.x+self.frame.size.width }
    public func setRight (newRight: CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newRight - self.size.width
        self.frame = newFrame
    }
}

// CGRect
public extension CGRect {
    //FrameAccessor
    public var x: CGFloat { return self.origin.x }
    public mutating func setX (newX: CGFloat) {
        var newFrame = self
        newFrame.origin.x = newX
        self = newFrame
    }
    public var y: CGFloat { return self.origin.y }
    public mutating func setY (newY: CGFloat) {
        var newFrame = self
        newFrame.origin.y = newY
        self = newFrame
    }
    public var width: CGFloat { return self.size.width }
    public mutating func setWidth (newWidth: CGFloat) {
        var newFrame = self
        newFrame.size.width = newWidth
        self = newFrame
    }
    public var height: CGFloat { return self.size.height }
    public mutating func setHeight (newHeight: CGFloat) {
        var newFrame = self
        newFrame.size.height = newHeight
        self = newFrame
    }
    public var bottom: CGFloat { return self.origin.y+self.size.height }
    public mutating func setBottom (newBottom: CGFloat) {
        var newFrame = self
        newFrame.origin.y = newBottom - self.size.height
        self = newFrame
    }
    public var right: CGFloat { return self.origin.x+self.size.width }
    public mutating func setRight (newRight: CGFloat) {
        var newFrame = self
        newFrame.origin.x = newRight - self.size.width
        self = newFrame
    }
}

// UIImage
public extension UIImage {
    //特定の色で塗りつぶされたUIImageを生成
    //usage: UIImage(color: .red, size: .init(width: 100, height: 100))
    public convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            self.init()
            return
        }
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    //画像を別の色で塗りつぶす (透明色は塗りつぶさない)
    //usage: fooImage.image(withTint: .red)
    public func image(withTint color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return UIImage()
        }
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -self.size.height)
        context.clip(to: rect, mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}

//配列でオブジェクトのインスタンスを検索して削除
//usage↓
/*let array = ["foo", "bar"]
array.remove(element: "foo")*/
public extension Array where Element: Equatable {
    @discardableResult
    public mutating func remove(element: Element) -> Index? {
        guard let index = index(of: element) else { return nil }
        remove(at: index)
        return index
    }
    
    @discardableResult
    public mutating func remove(elements: [Element]) -> [Index] {
        return elements.flatMap { remove(element: $0) }
    }
}

//配列から同一の値を削除
/*let array = [1, 2, 3, 3, 2, 1, 4]
array.unify() // [1, 2, 3, 4]*/
public extension Array where Element: Hashable {
    public mutating func unify() {
        self = unified()
    }
}
public extension Collection where Element: Hashable {
    public func unified() -> [Element] {
        return reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}

//２つのDictionaryを結合
//usage↓
/*var dic1 = ["key1": 1]
let dic2 = ["key2": 2]
dic1.merge(contentsOf: dic2) // => ["key1": 1, "key2": 2]*/
public extension Dictionary {
    public mutating func merge<S: Sequence>(contentsOf other: S) where S.Iterator.Element == (key: Key, value: Value) {
        for (key, value) in other {
            self[key] = value
        }
    }
    
    public func merged<S: Sequence>(with other: S) -> [Key: Value] where S.Iterator.Element == (key: Key, value: Value) {
        var dic = self
        dic.merge(contentsOf: other)
        return dic
    }
}


public extension String {
    //NSLocalizedStringを使いやすくする
    //usage: let message = "Hello".localized
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    public func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
    
    //様々なRangeで部分文字列を取得
    /*let string = "0123456789"
     string[0...5] //=> "012345"
     string[1...3] //=> "123"
     string[3..<7] //=> "3456"
     string[...4]  //=> "01234
     string[..<4]  //=> "0123"
     string[4...]  //=> "456789"*/
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    public subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    public subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
    
    //全角/半角文字列の変換
    /*let string = "１２3ＡＢcdeあいう"
     string.halfWidth //=> "123ABcdeあいう"
     string.fullWidth //=> "１２３ＡＢｃｄｅあいう"*/
    public var halfWidth: String {
        return transformFullWidthToHalfWidth(reverse: false)
    }
    
    public var fullWidth: String {
        return transformFullWidthToHalfWidth(reverse: true)
    }
    
    private func transformFullWidthToHalfWidth(reverse: Bool) -> String {
        let string = NSMutableString(string: self) as CFMutableString
        CFStringTransform(string, nil, kCFStringTransformFullwidthHalfwidth, reverse)
        return string as String
    }
    
    //文字列からURLを作成
    //usage: if let url = "https://example.com".url {}
    public var url: URL? {
        return URL(string: self)
    }
    
    //
    public var removeWhiteSpace: String {
        let words: [String] = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return words.joined(separator: "")
    }
    public var removeHyphen: String {
        return self.replacingOccurrences(of: "-", with: "")
    }
}

//文字列からURLを作成
//usage: let url: URL = "https://example.com"
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            fatalError("\(value) is an invalid url")
        }
        self = url
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

//クラスのプロパティを全て出力
//usage↓
/*class Hoge: NSObject {
    var foo = 1
    let bar = "bar"
}
Hoge().described // => "foo: 1\nbar: bar"*/
public extension NSObjectProtocol {
    public var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
            }
            .joined(separator: "\n")
    }
}

//???でOptionalをErrorとしてThrowできるようにする
/*let value: String? = nil
struct OptionalError: Error {}
do {
    let v = try value ??? OptionalError()
    print(v) // 到達不能
} catch {
    print(error) //=> OptionalError
}*/
infix operator ???
public func ???<T>(lhs: T?,
                   error: @autoclosure () -> Error) throws -> T {
    guard let value = lhs else { throw error() }
    return value
}

//Dictionaryの値取得時にkeyがなければErrorをThrowする
/*var dictionary: [String: Int] = [:]
do {
    let value = try dictionary.tryValue(forKey: "foo")
    print(value) // 到達不能
} catch {
    print(error) //=> DictionaryTryValueError
}*/
public struct DictionaryTryValueError: Error {
    public init() {}
}
public extension Dictionary {
    func tryValue(forKey key: Key, error: Error = DictionaryTryValueError()) throws -> Value {
        guard let value = self[key] else { throw error }
        return value
    }
}

//UIAlertControllerをBuilderパターンっぽく扱う
//usage↓
/*UIAlertController(title: "ログイン", message: "IDを入力してください", preferredStyle: .alert)
    .addTextField { textField in
        textField.placeholder = "ID"
    }
    .addActionWithTextFields(title: "OK") { action, textFields in
        // validation
    }
    .addAction(title: "キャンセル", style: .cancel)
    .show()*/
public extension UIAlertController {
    func addAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style, handler: handler)
        addAction(okAction)
        return self
    }
    
    func addActionWithTextFields(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
            handler?(action, self?.textFields ?? [])
        }
        addAction(okAction)
        return self
    }
    
    func configureForIPad(sourceRect: CGRect, sourceView: UIView? = nil) -> Self {
        popoverPresentationController?.sourceRect = sourceRect
        if let sourceView = UIApplication.shared.topViewController?.view {
            popoverPresentationController?.sourceView = sourceView
        }
        return self
    }
    
    func configureForIPad(barButtonItem: UIBarButtonItem) -> Self {
        popoverPresentationController?.barButtonItem = barButtonItem
        return self
    }
    
    func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
        addTextField(configurationHandler: handler)
        return self
    }
    
    func show() {
        UIApplication.shared.topViewController?.present(self, animated: true, completion: nil)
    }
}

////XIBのViewを生成
///*// XIB名とクラス名が同じ & 0番目のView
//final class View: UIView, NibInstantiatable {
//}
//View.instantiate()
//
//// XIB名とクラス名が異なる & 2番目のView
//final class View2: UIView, NibInstantiatable {
//    static var nibName: String { return "Foo" } // Foo.xib
//    static var instantiateIndex: Int { return 2 }
//}
//View2.instantiate()*/
//public protocol NibInstantiatable {
//    static var nibName: String { get }
//    static var nibBundle: Bundle { get }
//    static var nibOwner: Any? { get }
//    static var nibOptions: [AnyHashable: Any]? { get }
//    static var instantiateIndex: Int { get }
//}
//public extension NibInstantiatable where Self: NSObject {
//    public static var nibName: String { return className }
//    public static var nibBundle: Bundle { return Bundle(for: self) }
//    public static var nibOwner: Any? { return self }
//    public static var nibOptions: [AnyHashable: Any]? { return nil }
//    public static var instantiateIndex: Int { return 0 }
//}
//public extension NibInstantiatable where Self: UIView {
//    public static func instantiate() -> Self {
//        let nib = UINib(nibName: nibName, bundle: nibBundle)
//        return nib.instantiate(withOwner: nibOwner, options: nibOptions)[instantiateIndex] as! Self
//    }
//}
//
////StoryboardのViewControllerを生成
///*// クラス名とStoryboard名、Storyboard IDが同じ
//final class ViewController: UIViewController, StoryboardInstantiatable {
//}
//ViewController.instantiate()
//
//// Is Initial View Controllerにチェックを入れている & クラス名とStoryboard名が同じ
//final class InitialViewController: UIViewController, StoryboardInstantiatable {
//    static var instantiateType: StoryboardInstantiateType {
//        return .initial
//    }
//}
//InitialViewController.instantiate()*/
//public enum StoryboardInstantiateType {
//    case initial
//    case identifier(String)
//}
//public protocol StoryboardInstantiatable {
//    static var storyboardName: String { get }
//    static var storyboardBundle: Bundle { get }
//    static var instantiateType: StoryboardInstantiateType { get }
//}
//public extension StoryboardInstantiatable where Self: NSObject {
//    public static var storyboardName: String {
//        return className
//    }
//
//    public static var storyboardBundle: Bundle {
//        return Bundle(for: self)
//    }
//
//    private static var storyboard: UIStoryboard {
//        return UIStoryboard(name: storyboardName, bundle: storyboardBundle)
//    }
//
//    public static var instantiateType: StoryboardInstantiateType {
//        return .identifier(className)
//    }
//}
//public extension StoryboardInstantiatable where Self: UIViewController {
//    public static func instantiate() -> Self {
//        switch instantiateType {
//        case .initial:
//            return storyboard.instantiateInitialViewController() as! Self
//        case .identifier(let identifier):
//            return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
//        }
//    }
//}

