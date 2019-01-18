//
//  NCNotificationManager.swift
//  NepalCommunity
//
//  Created by guest on 2018/10/25.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

class NCNotificationManager: NSObject{

  //MARK: - Base Remove
  static func remove(_ observer:Any){
    NotificationCenter.default.removeObserver(observer)
  }
  
  //MARK: - Base Post
  private static func post(notificationName: NSNotification.Name, object:Any?, userInfo: [AnyHashable: Any]?){
    NotificationCenter.default.post(name: notificationName, object: object, userInfo : userInfo)
  }
  
  private static func post(name: String, object: Any?, userInfo: [AnyHashable : Any]? = nil){
    self.post(notificationName: NSNotification.Name(name), object: object, userInfo: userInfo)
  }
  
  //MARK: - Base Receive
  private static func receive(notificationName: NSNotification.Name, observer: Any, selector: Selector){
    NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
  }
  private static func receive(name:String, observer: Any,selector:Selector){
    self.receive(notificationName: NSNotification.Name(name), observer: observer, selector: selector)
  }
}


extension NCNotificationManager{
  //MARK: - Keyboard
  static func receive(keyboardDidChangeFrame observer:Any, selector:Selector) {
    let name = UIResponder.keyboardDidChangeFrameNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardDidHide observer:Any, selector:Selector) {
    let name = UIResponder.keyboardDidHideNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillChangeFrame observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillChangeFrameNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillHide observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillHideNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  static func receive(keyboardWillShow observer:Any, selector:Selector) {
    let name = UIResponder.keyboardWillShowNotification
    self.receive(notificationName: name, observer: observer, selector: selector)
  }
  
  //MARK:- Menu Button Pressed
  
  
  private static let N_MENU_BUTTON_PRESSED = "N_MENU_BUTTON_PRESSED"
  static func post(menuButtonPressed id: String, type :String, uid : String,ouid : String){
    var userInfo : [AnyHashable : Any] = [AnyHashable : Any]()
    userInfo["id"] = id
    userInfo["type"] = type
    userInfo["uid"] = uid
    userInfo["owner_uid"] = ouid
    self.post(name: N_MENU_BUTTON_PRESSED, object: userInfo)
  }
  static func receive(menuButtonPressed observer :Any, selector :Selector){
    receive(name: N_MENU_BUTTON_PRESSED, observer: observer, selector: selector)
  }
}
