//
//  Extensions.swift
//  Focus
//
//  Created by Shuo Tong on 7/8/15.
//  Copyright (c) 2015 Shuo Tong. All rights reserved.
//

import UIKit

extension UIStoryboard {
  
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func findNavigationController() -> UINavigationController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("FindNavigationController") as? UINavigationController
  }
  
}