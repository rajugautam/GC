//
//  CustomButton.swift
//  GoldCleats
//
//  Created by Raju Gautam on 10/29/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGSize = (self.imageView?.image?.size)!
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + 6), 0.0)
        
        let fontName = [NSFontAttributeName:UIFont(name: "AvenirNext-Medium", size: 14.0)!]
        let titleSize:CGSize = (self.titleLabel?.text!.sizeWithAttributes(fontName))!
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + 6.0), 0.0, 0.0, -titleSize.width);
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + 6), 0.0)
//        
//        if let imageView = self.imageView {
//            imageView.frame.origin.x = (self.bounds.size.width - imageView.frame.size.width) / 2.0
//            imageView.frame.origin.y = 0.0
//        }
//        if let titleLabel = self.titleLabel {
//            titleLabel.frame.origin.x = (self.bounds.size.width - titleLabel.frame.size.width) / 2.0
//            titleLabel.frame.origin.y = self.bounds.size.height - titleLabel.frame.size.height
//        }
    }

}
