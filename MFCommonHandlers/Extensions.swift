//
//  Extensions.swift
//  PublickBooking
//
//  Created by Mfluid 3 on 7/6/17.
//  Copyright © 2017 Mfluid. All rights reserved.
//

import UIKit

class Extensions: NSObject {
    
}

//MARK: - To customize image with different colors
extension UIImage {
    public func maskWithColor(color: UIColor) -> UIImage {
        
        var maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.setFillColor(color.cgColor)
        bitmapContext!.fill(bounds)
        
        let cImage = bitmapContext!.makeImage()
        let coloredImage = UIImage(cgImage: cImage!)
        
        return coloredImage
    }
    
    public static func multiplyImageByConstantColor(image:UIImage,color:UIColor)->UIImage{
        let backgroundSize = image.size
        UIGraphicsBeginImageContext(backgroundSize)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        var backgroundRect=CGRect()
        backgroundRect.size = backgroundSize
        backgroundRect.origin.x = 0
        backgroundRect.origin.y = 0
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        
        
        ctx?.setFillColor(red: r, green: g, blue: b, alpha: a)
        ctx?.fill(backgroundRect)
        
//        CGContextSetRGBFillColor(ctx, r, g, b, a)
//        CGContextFillRect(ctx, backgroundRect)
        
        var imageRect=CGRect()
        imageRect.size = image.size
        imageRect.origin.x = (backgroundSize.width - image.size.width)/2
        imageRect.origin.y = (backgroundSize.height - image.size.height)/2
        
        // Unflip the image
        //CGContextTranslateCTM(ctx ?? <#default value#>, 0, backgroundSize.height)
        //CGContextScaleCTM(ctx ?? <#default value#>, 1.0, -1.0)
        
        ctx?.translateBy(x: 0, y:  backgroundSize.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        
//        CGContextSetBlendMode(ctx, .Multiply)
//        CGContextDrawImage(ctx, imageRect, image.CGImage)
        
        ctx?.setBlendMode(.multiply)
        ctx?.draw(image.cgImage!, in:imageRect)
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
   
        public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
            //Calculate the size of the rotated view's containing box for our drawing space
            let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
            rotatedViewBox.transform = t
            let rotatedSize: CGSize = rotatedViewBox.frame.size
            //Create the bitmap context
            UIGraphicsBeginImageContext(rotatedSize)
            let bitmap: CGContext = UIGraphicsGetCurrentContext()!
            //Move the origin to the middle of the image so we will rotate and scale around the center.
            bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            //Rotate the image context
            bitmap.rotate(by: (degrees * CGFloat.pi / 180))
            //Now, draw the rotated/scaled image into the context
            bitmap.scaleBy(x: 1.0, y: -1.0)
            bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        
        
        public func fixedOrientation() -> UIImage {
            if imageOrientation == UIImage.Orientation.up {
                return self
            }
            
            var transform: CGAffineTransform = CGAffineTransform.identity
            
            switch imageOrientation {
            case UIImageOrientation.down, UIImageOrientation.downMirrored:
                transform = transform.translatedBy(x: size.width, y: size.height)
                transform = transform.rotated(by: CGFloat.pi)
                break
            case UIImageOrientation.left, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.rotated(by: CGFloat.pi/2)
                break
            case UIImageOrientation.right, UIImageOrientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: size.height)
                transform = transform.rotated(by: -CGFloat.pi/2)
                break
            case UIImageOrientation.up, UIImageOrientation.upMirrored:
                break
            }
            
            switch imageOrientation {
            case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
                transform.translatedBy(x: size.width, y: 0)
                transform.scaledBy(x: -1, y: 1)
                break
            case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
                transform.translatedBy(x: size.height, y: 0)
                transform.scaledBy(x: -1, y: 1)
            case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
                break
            }
            
            let ctx: CGContext = CGContext(data: nil,
                                           width: Int(size.width),
                                           height: Int(size.height),
                                           bitsPerComponent: self.cgImage!.bitsPerComponent,
                                           bytesPerRow: 0,
                                           space: self.cgImage!.colorSpace!,
                                           bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
            case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                break
            }
            
            let cgImage: CGImage = ctx.makeImage()!
            
            return UIImage(cgImage: cgImage)
        }

    
   
    
    
    
}
//MARK: - extension for String
extension String {
    
    
   public var length : Int {
        return self.characters.count
    }
    
    public func digitsOnly() -> String{
        
        
        
        let stringArray = components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        
        return newString
    }
    
    public var ConvertTofloatValue: Float {
        return (self as NSString).floatValue
    }
    
    // MARK: Localization helper
    public func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        
        if let  path = Bundle.main.path(forResource: lang, ofType: "lproj"){
            
            let bundle = Bundle(path: path)
            
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
            
            
        } else{
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            
            let bundle = Bundle(path: path!)
            
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
            
        }
        
        
    }
    
    
   
        public var isEmptyField: Bool {
            return trimmingCharacters(in: .whitespaces).isEmpty
        }
    
    
    
    
}
extension Double {
    /// Rounds the double to decimal places value
    public func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIColor {
    public convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
//extension UILabel {
//    
//    func startAnimate() {
//        
//        DispatchQueue.main.async {
//            
//            
//            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat,.autoreverse], animations: {
//                self.alpha = 0.0
//                
//            }, completion: { (Bool) in
//                
//                self.alpha = 1.0
//            })
//        }
//    }
//    func stopAnimation() {
//        
//        DispatchQueue.main.async {
//            self.alpha = 1.0
//            self.layer.removeAllAnimations()
//        }
//    }
//    
//    private struct AssociatedKeys {
//        static var padding = UIEdgeInsets()
//    }
//    
//    public var padding: UIEdgeInsets? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
//    
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
//    
//    override open var intrinsicContentSize: CGSize {
//        guard let text = self.text else { return super.intrinsicContentSize }
//
//        var contentSize = super.intrinsicContentSize
//        var textWidth: CGFloat = frame.size.width
//        var insetsHeight: CGFloat = 0.0
//
//        if let insets = padding {
//            textWidth -= insets.left + insets.right
//            insetsHeight += insets.top + insets.bottom
//        }
//
//        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
//                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                        attributes: [NSFontAttributeName: self.font], context: nil)
//
//        contentSize.height = ceil(newSize.size.height) + insetsHeight
//
//        return contentSize
//    }
//    
//    
//    
//    
//}
extension NSAttributedString {
    
    
    public func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    
    public func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
extension String {
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
}
extension NSObject {
    public var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

extension String {
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


struct Meter {
    public var value: Double
    
    public init(_ value: Double) {
        self.value = value
    }
    
    var mm: Double { return value * 1000.0 }
    var km: Double { return value / 1000.0 }
}
extension Double {
    /// Rounds the double to decimal places value
    public func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    /// Rounds the double to decimal places value
    public func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}


extension Date {
    public var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    
    
}


extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension String {
    public func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
}

extension UITextField{
//    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(paste(_:)) {
//            return false
//        }
//
//        return super.canPerformAction(action, withSender: sender)
//    }
//
    public func padd(iPad:Bool = false) -> UIView{
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        if iPad == true{
            
            view.frame = CGRect(x:0, y: 0, width: 15, height: 20)
            return view
            
           //return UIView(frame: CGRect(x:0, y: 0, width: 5, height: 20))
            
        }
        view.frame = CGRect(x:0, y: 0, width: 10, height: 10)
        return view
        
    }
    
//    func leftPadd(textField:UITextField,iPad:Bool = false) -> UIView{
//
//        if iPad == true{
//
//            return UIView(frame: CGRect(x: 5, y: 0, width: 5, height: 20))
//
//        }
//
//        return UIView(frame: CGRect(x:5, y: 0, width: 5, height: 20))
//
//    }
    
    
    
    
}

extension UITextView{
    
    
}
var AssociatedObjectHandle2: UInt8 = 0
extension UIButton {
    // new functionality to add to SomeType goes here
    
    public var buttonIdentifier:String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle2) as! String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle2, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

public extension UIDevice {
    
    public var modelNameString: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

public extension UIDevice {
    
    public var modelName: Devices {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return Devices.IPodTouch5
        case "iPod7,1":                                 return Devices.IPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return Devices.IPhone4
        case "iPhone4,1":                               return Devices.IPhone4S
        case "iPhone5,1", "iPhone5,2":                  return Devices.IPhone5
        case "iPhone5,3", "iPhone5,4":                  return Devices.IPhone5C
        case "iPhone6,1", "iPhone6,2":                  return Devices.IPhone5S
        case "iPhone7,2":                               return Devices.IPhone6
        case "iPhone7,1":                               return Devices.IPhone6Plus
        case "iPhone8,1":                               return Devices.IPhone6S
        case "iPhone8,2":                               return Devices.IPhone6SPlus
        case "iPhone9,1", "iPhone9,3":                  return Devices.IPhone7
        case "iPhone9,2", "iPhone9,4":                  return Devices.IPhone7Plus
        case "iPhone8,4":                               return Devices.IPhoneSE
        case "iPhone10,1", "iPhone10,4":                return Devices.IPhone8
        case "iPhone10,2", "iPhone10,5":                return Devices.IPhone8Plus
        case "iPhone10,3", "iPhone10,6":                return Devices.IPhoneX
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return Devices.IPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return Devices.IPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return Devices.IPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return Devices.IPadAir
        case "iPad5,3", "iPad5,4":                      return Devices.IPadAir2
        case "iPad6,11", "iPad6,12":                    return Devices.IPad5
        case "iPad2,5", "iPad2,6", "iPad2,7":           return Devices.IPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return Devices.IPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return Devices.IPadMini3
        case "iPad5,1", "iPad5,2":                      return Devices.IPadMini4
        case "iPad6,3", "iPad6,4":                      return Devices.IPadPro_9_7
        case "iPad6,7", "iPad6,8":                      return Devices.IPadPro_12_9
        case "iPad7,1", "iPad7,2":                      return Devices.IPadPro_12_9_2ndGen
        case "iPad7,3", "iPad7,4":                      return Devices.IPadPro_10_5
        case "AppleTV5,3":                              return Devices.AppleTV_5_3
        case "AppleTV6,2":                              return Devices.AppleTV_6_2
        case "AudioAccessory1,1":                       return Devices.HomePod
        case "i386", "x86_64":                          return Devices.Simulator
        default:                                        return Devices.Other
        }
    }
}

public enum Devices: String {
    case IPodTouch5
    case IPodTouch6
    case IPhone4
    case IPhone4S
    case IPhone5
    case IPhone5C
    case IPhone5S
    case IPhone6
    case IPhone6Plus
    case IPhone6S
    case IPhone6SPlus
    case IPhone7
    case IPhone7Plus
    case IPhoneSE
    case IPhone8
    case IPhone8Plus
    case IPhoneX
    case IPad2
    case IPad3
    case IPad4
    case IPad5
    case IPadAir
    case IPadAir2
    case IPadMini
    case IPadMini2
    case IPadMini3
    case IPadMini4
    case IPadPro_9_7
    case IPadPro_12_9
    case IPadPro_12_9_2ndGen
    case IPadPro_10_5
    case AppleTV_5_3
    case AppleTV_6_2
    case HomePod
    case Simulator
    case Other
}


    


