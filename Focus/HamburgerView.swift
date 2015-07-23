//
//  HamburgerVIew.swift
//  Focus
//
//  Created by Shuo Tong on 7/3/15.
//  Copyright (c) 2015 Shuo Tong. All rights reserved.
//

import UIKit

class HamburgerView: UIView {
  
  let imageView: UIImageView! = UIImageView(image: UIImage(named: "Hamburger"))
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  // MARK: RotatingView
  
  func rotate(fraction: CGFloat) {
    let angle = Double(fraction) * M_PI_2
    imageView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
  }
  
  // MARK: Private
  
  private func configure() {
    imageView.contentMode = UIViewContentMode.Center
    addSubview(imageView)
  }
  
}
