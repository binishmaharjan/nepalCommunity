//
//  NCDelayExce.swift
//  NepalCommunity
//
//  Created by guest on 2019/02/14.
//  Copyright © 2019年 guest. All rights reserved.
//

import UIKit

class NCDelayExce{
  private var workItem:DispatchWorkItem?
  //タイマーメソッド methodがデフォルトだと10sec後に実行される
  func run(afterTime:Double = 10.0, _ method:(()->())?){
    self.workItem?.cancel()
    self.workItem = nil
    let workItem = DispatchWorkItem { method?() }
    DispatchQueue.main.asyncAfter(deadline: .now() + afterTime, execute: workItem)
    self.workItem = workItem
  }
  //キャンセルメソッド
  func cancel(){self.workItem?.cancel()}
}
/*
 self.delayedExec.run(afterTime:5.0){MQLoader.show(isAnytimeShow:true)}
 self.delayedExec.cancel()
 MQLoader.dismiss()
 */
