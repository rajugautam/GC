//
//  GCSpotlightCircle.swift
//  GoldCleats
//
//  Created by Raju Gautam on 11/6/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

import UIKit

public class GCSpotlightCircle {
    public var cropRect = CGRectZero
    private var transparentView_:UIView?
    private var parentView_:UIView?

    
    // call this in viewDidLoad
    public func setup(transparentView:UIView, parentView:UIView, showAnchors:Bool) {
        transparentView_ = transparentView
        parentView_ = parentView
    }
    
    // call this in viewDidAppear
    public func present() {
        layoutViewsForCropRect()
    }
    
    // MARK:- layout
    public func layoutViewsForCropRect() {
        addMaskRectView()
    }
    
    private func addMaskRectView() {
        let bounds = CGRectMake(0, 0, transparentView_!.frame.size.width,
            transparentView_!.frame.size.height)
        
        let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.blackColor().CGColor
//        let path = UIBezierPath(rect: cropRect)
//        path.appendPath(UIBezierPath(rect: bounds))
//        maskLayer.path = path.CGPath
//        maskLayer.fillRule = kCAFillRuleEvenOdd
//        
//        transparentView_!.layer.mask = maskLayer
        
        let path = UIBezierPath(ovalInRect: cropRect)//UIBezierPath(arcCenter: cropRect.!, radius: 60, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true);
        path.appendPath(UIBezierPath(rect: bounds))
        maskLayer.path = path.CGPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        transparentView_!.layer.mask = maskLayer
    }
}
