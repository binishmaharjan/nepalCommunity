//
//  NCDate.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/14.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation

class NCDate{
  
  static func dateToString()->String{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return formatter.string(from: Date())
  }
  
  static func stringToDateTime(string : String)->Date{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    if let date = formatter.date(from: string){
      return date
    }else{
      return Date()
    }
  }
  
  static func stringToDate(string : String)->Date{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: string){
      return date
    }else{
      return Date()
    }
  }
}
