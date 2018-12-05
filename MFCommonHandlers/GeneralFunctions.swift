//
//  GeneralFunctions.swift
//  MFCommonHandlers
//
//  Created by Hasanul Benna on 29/11/18.
//  Copyright © 2018 Mfluid. All rights reserved.
//

import Foundation
import UIKit

public class GeneralFunctions {

// MARK: - Create toast method
/**
 @Des: Public method to create toast instead of default alerts
 - parameters:
 - onView: view on which toast needed to display
 - message: message to be displayed
 - positionY: Y position to display toast
 - return:
 -nil
 
 */
    public func createToastWithMessage(onView:UIView,message:String,positionY:CGFloat,fontString:String){
    
    
    //let fontObject = FontFile()
    let window =  UIApplication.shared.keyWindow
    let bgWindow = UIView(frame:CGRect(x:0,y:0,width:(window?.frame.width)!,height:(window?.frame.height)!))
    //var toastfont = fontObject.setFont(13)
        
     var toastfont = UIFont(name: fontString, size: 13) ?? UIFont(name: "SanFranciscoDisplay-Regular", size: 13)
    var toastWidth = 300
    if UI_USER_INTERFACE_IDIOM() == .pad {
        //toastfont = fontObject.setFont(15)
        
        toastfont = UIFont(name: fontString, size: 15) ?? UIFont(name: "SanFranciscoDisplay-Regular", size: 15)
        toastWidth = 500
    }
    if let toast = window?.viewWithTag(00700)
    {
        toast.removeFromSuperview()
    }
    let toastLabel =
        UILabel(frame:
            CGRect(x: (window?.frame.size.width)!/2 - CGFloat(toastWidth/2),
                   y: positionY,
                   width: CGFloat(toastWidth),
                   height: heightWithConstrainedWidthQuestionair(message as NSString, width: CGFloat(toastWidth-20), font: toastfont!)))
    bgWindow.backgroundColor = .none
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    toastLabel.textColor = UIColor.white
    toastLabel.font = toastfont
    toastLabel.numberOfLines = 20
    toastLabel.lineBreakMode = .byWordWrapping
    toastLabel.textAlignment = NSTextAlignment.center
    toastLabel.tag = 00700
    
    
    //bgWindow.addSubview(toastLabel)
    window?.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    
    if message.characters.count > 30
    {
        UIView.animate(withDuration: 15.0, animations: {
            toastLabel.alpha = 0.0
            bgWindow.alpha = 0.0
        })
        
    }
    else
    {
        UIView.animate(withDuration: 6.0, animations: {
            toastLabel.alpha = 0.0
            bgWindow.alpha = 0.0
        })
    }
    
}
    
    public  func heightWithConstrainedWidthQuestionair(_ text : NSString, width: CGFloat, font: UIFont) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font=font
        
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text as String
        
        label.sizeToFit()
        return label.frame.height+30
        
        //return label.frame.height
    }
    
    
    public func localisationString(_ key:String) ->String
        
    {
        
        var path : NSString
        let lan : NSString = (UserDefaults.standard.value(forKey: "language") ?? "en") as! NSString
        if(lan == "en"){
            
            
            path = Bundle.main.path(forResource: "en", ofType: "lproj")! as NSString
        }else if(lan=="fr"){
            path = Bundle.main.path(forResource: "fr", ofType: "lproj")! as NSString
        }else if(lan=="ml"){
            path = Bundle.main.path(forResource: "ml", ofType: "lproj")! as NSString
        }else if(lan=="hi"){
            path = Bundle.main.path(forResource: "hi", ofType: "lproj")! as NSString
        }else if(lan=="ta"){
            path = Bundle.main.path(forResource: "ta", ofType: "lproj")! as NSString
        }else if(lan=="te"){
            path = Bundle.main.path(forResource: "te", ofType: "lproj")! as NSString
        }
        else
        {
            path = Bundle.main.path(forResource: "ar", ofType: "lproj")! as NSString
            
        }
        let bundle = Bundle(path: path as String)
        
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    //MARK: - fetching keyboard code
    public func setKeyBoardCode(languageCode: String) -> String {
        var keyBoardCode = "en-US"
        if languageCode == "en" {
            keyBoardCode = "en-US"
        } else if languageCode == "en" {
            keyBoardCode = "en-US"
            
        } else if languageCode == "hi" {
            
            keyBoardCode = "hi"
            
        } else if languageCode == "ml" {
            
            keyBoardCode = "ml"
            
        } else if languageCode == "ta" {
            keyBoardCode = "ta"
            
        } else if languageCode == "te" {
            keyBoardCode = "te"
            
        } else if languageCode == "kn" {
            keyBoardCode = "en-US"
            
        } else {
            keyBoardCode = "en-US"
        }
        return keyBoardCode
    }
    
    
    // MARK: - Download description audio/Image
    /**
     downloadFile
     @Des: This method will download the description audio/Image and save it in document directory
     - parameters:
     - audioPath: URL string of description audio from response data
     */
    public func downloadFile(audioPath : String,finished:@escaping (_ success:String) -> Void){
        
        if let audioUrl = URL(string: audioPath) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            //print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                //print("The file already exists at path")
                finished("error")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        //print("File moved to documents folder")
                        finished(String(describing:destinationUrl))
                        
                    } catch let error as NSError {
                        //print(error.localizedDescription)
                        finished("error")
                    }
                }).resume()
                
                
                
                
            }
        }
        
        finished("error")
        
    }
    
    
    public func getPathForDownloadedAudio(audioPath : String) -> URL {
        
        if let audioUrl = URL(string: audioPath) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            //print(destinationUrl)
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            return destinationUrl
            
        }
        
        let urlString = (audioPath ).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        //guard
        let url = URL(string: urlString!)
        //print(url)
        //            else {
        //            //print("Stream Error ")
        //            return
        //        }
        return url!
    }
    
    
    // MARK: - split filename
    
    public func splitFilename(str: String) -> (directory: String, filenameWithExtension: String, ext: String) {
        let url = URL(fileURLWithPath: str)
        
        //print(url.deletingLastPathComponent().path)
        //print(url.deletingPathExtension().lastPathComponent)
        //print(url.pathExtension)
        
        return (url.deletingLastPathComponent().path, url.lastPathComponent, url.pathExtension)
    }
    
    
    
}


