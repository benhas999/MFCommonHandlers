//
//  TextUtils.swift
//  OrixPublicBooking
//
//  Created by askar c on 1/26/17.
//  Copyright © 2017 DT. All rights reserved.
//

import Foundation
import UIKit

class Validate {
   public static func isEmpty(_ paramField:UITextField) -> Bool {
    if let param = paramField.text , !param.isEmpty , !((paramField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))?.isEmpty)!
        {
            return false;
        }
        return true
    }
   
    public static func isEmpty(_ param:String?) -> Bool {
        if param != nil && !(param?.isEmpty)!
        {
            return false;
        }
        return true
    }
    public static func isEmpty(_ param:Array<Any>?) -> Bool {
        if param != nil && !(param?.isEmpty)! && (param?.count)!>0
        {
            return false;
        }
        return true
    }
    public static func isValidEmail(_ param:String) -> Bool {
        let email = param.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    public static func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }

    // MARK: - Phone number validation
    /**
     "isValidPhoneNumber"
     @Des: Validate phone number
     - parameters:
     - phoneNo: Number to validate
     
     */
  public static  func  isValidPhoneNumber(phoneNo: String) -> Bool
    {
        // let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phoneNo)
        return result
    }
    
    
   public static func jsonResponseValidation(resultObject:NSDictionary) -> Bool {
        
        if resultObject.allKeys.count == 0{
            
          
            
            return false
        }
        
    if let statusKeyExists = resultObject["MessageType"] {
        
       return true
    }
        return false
        
    }
    
    public static func  isIphone() -> Bool{
        
        if UI_USER_INTERFACE_IDIOM() == .pad{
            
            return false
        }else{
            
            return true
        }
        
    }
    
   

}

