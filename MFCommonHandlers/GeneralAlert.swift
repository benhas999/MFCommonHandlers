//
//  GeneralAlert.swift
//  ServiceRequesterApp
//
//  Created by Mfluid Design on 21/06/17.
//  Copyright © 2017 Mfluid Apps Pvt. Ltd. All rights reserved.
//

import UIKit

public class GeneralAlert: UIView {
    
    
    var messageBase = UIView()
    
    // Setting pass values for message items
    var properties = Properties()
   
    
    public enum GeneralMessageType: Int {
        case singleAction, doubleAction
    }
    enum ActionType {
        case close, cancel
    }
    
    
    public override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    public convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    var closeAction: (()->Void)?
    var cancelAction: (()->Void)?
    
    public func addCloseAction(_ action: @escaping () -> Void) {
        self.closeAction = action
    }
    
    public func addCancelAction(_ action: @escaping () -> Void) {
        self.cancelAction = action
    }
    
   struct Properties{
    
    var TitleMessage:String?
    var TitleFont:UIFont?
    
   
    var TitleMessageTextFont:UIFont?
        
    var OkBg:UIColor?
    var OkFont:UIFont?
    
    var CancelBg:UIColor?
    var CancelFont:UIFont?
   
     }
    
    public func createProperties(TitleMessage:String? = nil,TitleFont: UIFont? = nil,TitleMessageTextFont: UIFont? = nil, OkBg: UIColor? = nil, OkFont: UIFont? = nil, CancelBg: UIColor? = nil, CancelFont: UIFont? = nil){
        
       properties.TitleMessage = TitleMessage ?? "Message"
       properties.TitleFont = TitleFont ?? UIFont(name: "HelveticaNeue-Bold", size: 17)
        properties.TitleMessageTextFont = TitleFont ?? UIFont(name: "HelveticaNeue-Bold", size: 15)
       properties.OkBg = OkBg ?? UIColor.green
       properties.OkFont = OkFont ?? UIFont(name: "HelveticaNeue-Bold", size: 17)
       properties.CancelBg = CancelBg ?? UIColor.red
       properties.CancelFont = CancelFont ??  UIFont(name: "HelveticaNeue-Bold", size: 17)
    }

    
    public func showAlert(parentView:UIViewController,message:String,type:GeneralMessageType,okButtonText: String?=nil,cancelButtonText: String?=nil) {
        
       
       
        
       
        let titleMessage = properties.TitleMessage
        let titleFont = properties.TitleFont
        
        let titleMessageText = message
        let titleMessageTextFont = properties.TitleMessageTextFont
        
        
       
        let okBg = properties.OkBg
        let okFont = properties.OkFont
        
        
        let cancelBg = properties.CancelBg
        let cancelFont = properties.CancelFont
        
        
        
        self.frame = CGRect(x: 0, y: 0, width: parentView.view.frame.size.width, height: parentView.view.frame.size.height)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        
        
        messageBase = UIView(frame:CGRect(x: 0, y: 0, width:parentView.view.frame.size.width, height: 250))
        
        messageBase.backgroundColor = UIColor.white
        
        
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: 60, width: messageBase.frame.width, height: 50))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = titleMessage
        label.font = titleFont
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        messageBase.addSubview(label)
        
        
        let height = self.heightForLabel(text: message, font: titleFont!, width: messageBase.frame.width-30)
        
        let label2:UILabel = UILabel(frame:CGRect(x: 15, y: label.frame.origin.y+label.frame.size.height, width: messageBase.frame.width-30, height: height))
        label2.text = titleMessageText
        label2.numberOfLines = 0
        label2.lineBreakMode = NSLineBreakMode.byWordWrapping
        label2.textColor = UIColor.darkGray
        label2.textAlignment = .center
        label2.font = titleMessageTextFont
        messageBase.addSubview(label2)
        
        var calculatedHeight = CGFloat()
        
        if type == .singleAction {
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y:label2.frame.origin.y+label2.frame.size.height+15, width: messageBase.frame.width, height:  50)
           button.backgroundColor = cancelBg //UIColor(hex: "47d2e9")//UIColor(hex: "ff544a")
            button.titleLabel?.font = cancelFont
            if let title = cancelButtonText{
                button.setTitle(title, for: .normal)
                
            }else{
                button.setTitle("OK".uppercased(), for: .normal)
            }
            
            
            button.addTarget(self, action: #selector(cancelMessage), for: .touchUpInside)
            messageBase.addSubview(button)
            
            calculatedHeight = button.frame.origin.y+button.frame.size.height
            
            if calculatedHeight < 150{
                
                calculatedHeight = 150
                
                button.frame = CGRect(x: 0, y:messageBase.frame.size.height-50, width: messageBase.frame.width, height:  50)
                
            }
            
        }else{
            
            let button1 = UIButton(type: .custom)
            button1.frame = CGRect(x: 0, y:label2.frame.origin.y+label2.frame.size.height+15, width: (messageBase.frame.width/2), height:  45)
            button1.backgroundColor = cancelBg
            button1.titleLabel?.font = cancelFont
            button1.setTitleColor(UIColor.white, for: .normal)
            if let title = cancelButtonText{
                button1.setTitle(title, for: .normal)
                
            }else{
                button1.setTitle("cancel".uppercased(), for: .normal)
            }
            
            button1.addTarget(self, action: #selector(cancelMessage), for: .touchUpInside)
            messageBase.addSubview(button1)
            
            let button2 = UIButton(type: .custom)
            button2.frame = CGRect(x:(messageBase.frame.width/2), y:label2.frame.origin.y+label2.frame.size.height+15, width: (messageBase.frame.width/2)-0.5, height:  45)
            button2.backgroundColor = okBg//UIColor(hex: "47d2e9")
            button2.setTitleColor(UIColor.white, for: .normal)
            button2.titleLabel?.font = okFont
            if let title = okButtonText{
                button2.setTitle(title, for: .normal)
                
            }else{
                button2.setTitle("ok".uppercased(), for: .normal)
            }
            
            
            button2.addTarget(self, action: #selector(doneCloseAction), for: .touchUpInside)
            messageBase.addSubview(button2)
            
            calculatedHeight = button1.frame.origin.y+button1.frame.size.height
            
            if calculatedHeight < 150{
                
                calculatedHeight = 150
                
                button1.frame = CGRect(x: 0, y:messageBase.frame.size.height-50, width: (messageBase.frame.width/2), height:  45)
                button2.frame = CGRect(x:(messageBase.frame.width/2), y:messageBase.frame.size.height-50, width: (messageBase.frame.width/2)-0.5, height:  45)
                
            }
            
            
            
        }
        messageBase.frame = CGRect(x: 0, y: -messageBase.frame.size.height, width:parentView.view.frame.size.width, height:calculatedHeight)
        
        
        messageBase.alpha = 0
        
        self.addSubview(messageBase)
        
        //testing: add view to window
        let window = UIApplication.shared.keyWindow
//        window?.addSubview(messageBase)
        window?.addSubview(self)
        
//        parentView.view.addSubview(self)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.messageBase.alpha = 1
            self.messageBase.frame = CGRect(x: 0, y: 0, width:parentView.view.frame.size.width, height:calculatedHeight)
            
            self.alpha = 1
            
            
            
        }) { (bool) in
            
            
        }
        
        
    }
    
    @objc func cancelMessage()  {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.messageBase.frame = CGRect(x: 0, y: -self.messageBase.frame.size.height, width:self.frame.size.width, height:self.messageBase.frame.height)
            self.messageBase.alpha = 0
            self.alpha = 0
            
        }) { (bool) in
            
            self.cancelAction?()
            self.removeFromSuperview()
        }
    }
    
  
    @objc func doneCloseAction()  {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.messageBase.frame = CGRect(x: 0, y: -self.messageBase.frame.size.height, width:self.frame.size.width, height:self.messageBase.frame.height)
            self.messageBase.alpha = 0
            self.alpha = 0
            
        }) { (bool) in
            
            self.closeAction?()
            self.removeFromSuperview()
        }
        
        
        
    }
    
    
    // MARK: - Method to find the height of a label by its contained text
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        
        return label.frame.height
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}


//extension UIColor {
//    convenience init(hex: String) {
//        let scanner = Scanner(string: hex)
//        scanner.scanLocation = 0
//        
//        var rgbValue: UInt64 = 0
//        
//        scanner.scanHexInt64(&rgbValue)
//        
//        let r = (rgbValue & 0xff0000) >> 16
//        let g = (rgbValue & 0xff00) >> 8
//        let b = rgbValue & 0xff
//        
//        self.init(
//            red: CGFloat(r) / 0xff,
//            green: CGFloat(g) / 0xff,
//            blue: CGFloat(b) / 0xff, alpha: 1
//        )
//    }
//}

