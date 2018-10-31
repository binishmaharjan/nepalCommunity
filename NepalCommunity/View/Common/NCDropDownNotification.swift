//
//  NCDropDownNotification.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/31.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit


class NCDropDownNotification{
  
  private init(){}
  
  static let shared = NCDropDownNotification()
  private var isNotificationViewShowing = false
  private var appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  func showSuccess(message :String){
    showMessage(message: message, color: UIColor.green)
  }
  
  
  func showError(message : String){
    showMessage(message: message, color: UIColor.red)
  }
  
  func showMessage(message :String, color : UIColor){
    if isNotificationViewShowing == false{
      isNotificationViewShowing = true
      
      //Creating the red view
      let notificationView_height = UIApplication.shared.statusBarFrame.height + 44
      let notificationView_y : CGFloat = 0 - notificationView_height
      let colorNotification = color
      
      let notifiactionView : UIView = UIView(frame : CGRect(x: 0, y: notificationView_y, width: (appDelegate.window?.bounds.width)!, height: notificationView_height))
      notifiactionView.backgroundColor = colorNotification
      appDelegate.window?.addSubview(notifiactionView)
      
      //Error Label
      let notificationLabel_width = notifiactionView.bounds.width
      let notificationLabel_height = notifiactionView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
      
      let notificationLabel = UILabel()
      notificationLabel.frame.size.width = notificationLabel_width
      notificationLabel.frame.size.height = notificationLabel_height
      notificationLabel.numberOfLines = 0
      notificationLabel.text = message
      notificationLabel.font = NCFont.bold(size: 12)
      notificationLabel.textColor = .white
      notificationLabel.textAlignment = .center
      notifiactionView.addSubview(notificationLabel)
      
      //Animation
      UIView.animate(withDuration: 0.2, animations: {
        notifiactionView.frame.origin.y = 0
      }, completion: { (finished) in
        if finished{
          UIView.animate(withDuration: 0.1, delay: 2, options: .curveLinear, animations: {
            notifiactionView.frame.origin.y = notificationView_y
          }, completion: { (finished) in
            notifiactionView.removeFromSuperview()
            notificationLabel.removeFromSuperview()
            self.isNotificationViewShowing = false
          })
        }
      })
      
    }
  }
}
