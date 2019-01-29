//
//  NCSingleHomeViewDelegate.swift
//  NepalCommunity
//
//  Created by guest on 2018/12/06.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit


//Single Home View
protocol NCSingleHomeViewDelegate{
  func cellWasTapped(article : NCArticle, user: NCUser)
  func menuButtonWasPressed(article : NCArticle)
  func commentIconPressed(article : NCArticle, user :NCUser)
}

protocol NCSingleToPagerDelegate{
  func passFromSingleToPager(article:NCArticle, user : NCUser)
  func menuButtonWasPressed(article : NCArticle)
  func commentIconPressed(article : NCArticle, user :NCUser)
}

protocol NCPagerToHomeDelegate{
  func passFromPagerToHome(article:NCArticle, user :NCUser)
  func menuButtonWasPressed(article : NCArticle)
  func commentIconPressed(article : NCArticle, user :NCUser)
}

protocol NCArticleCellToSingleHomeDelegate{
  func passArticleAndUser(article: NCArticle, user: NCUser)
  func menuButtonWasPressed(article : NCArticle)
  func commentIconPressed(article : NCArticle, user :NCUser)
}



//Image
protocol NCImageDelegate{
  func imagePressed(image : UIImage)
}

protocol NCCellToTableViewDelegate{
  func passImageFromCellToTable(image: UIImage)
  func commentIconWasPressed()
}

protocol NCImageSelectionDelegate: NCImageDelegate {
  func showLibrary()
  func openCamera()
}

