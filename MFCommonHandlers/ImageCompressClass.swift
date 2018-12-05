//
//  ImageCompressClass.swift
//  DynamicImageUpload
//
//  Created by MFluid Apps on 21/04/17.
//  Copyright © 2017 MFluid Mobile Apps Pvt. Ltd. All rights reserved.
//

import UIKit

public class ImageCompressClass: NSObject {

    
    public func compressImageWith(originalImage:UIImage,mode:Int,sizeReductionPrecentage:Float,percentageOfQuality:Float) -> UIImage {
        
        
        let ImageCompressType = mode
        
        
        var imageToSend:UIImage?
        
        
        switch ImageCompressType {
        case 1:
            
            let percentageToReduce:Float = sizeReductionPrecentage
            let reducePercentageValueas:Float = percentageToReduce/Float(100)
            (reducePercentageValueas)
            
            
            let percentageResizedImage = originalImage.resized(withPercentage:CGFloat(reducePercentageValueas))
            (percentageResizedImage!)
            
            
            let compressData = UIImageJPEGRepresentation(percentageResizedImage!, 1) //max value is 1.0 and minimum is 0.0
            imageToSend = UIImage(data: compressData!)
            
            return imageToSend!
        case 2:
            
            let percentageToCompress:Float = percentageOfQuality
            let reduceCompressValue:Float = percentageToCompress/Float(100)
            (reduceCompressValue)
            
            
            let compressData = UIImageJPEGRepresentation(originalImage, CGFloat(reduceCompressValue)) //max value is 1.0 and minimum is 0.0
            imageToSend = UIImage(data: compressData!)
            
            
             return imageToSend!
        case 3:
            
            let percentageToReduce:Float = sizeReductionPrecentage
            let reducePercentageValueas:Float = percentageToReduce/Float(100)
            (reducePercentageValueas)
            
            
            let percentageResizedImage = originalImage.resized(withPercentage:CGFloat(reducePercentageValueas))
            (percentageResizedImage!)
            
            let percentageToCompress:Float = percentageOfQuality
            let reduceCompressValue:Float = percentageToCompress/Float(100)
            (reduceCompressValue)
            
            
            let compressData = UIImageJPEGRepresentation(percentageResizedImage!, CGFloat(reduceCompressValue)) //max value is 1.0 and minimum is 0.0
            imageToSend = UIImage(data: compressData!)
            
            
             return imageToSend!
            
        default:
            
            return originalImage
            
        }
    
        
    }
    
    public func resizeToWidth(originalImage:UIImage,toWidth:Float) -> UIImage {
        
        
      return originalImage.resized(toWidth: CGFloat(toWidth))!
        
    }
    
    
}
extension UIImage {
    public func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    public func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        // UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        //image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
}
