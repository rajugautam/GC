//
//  UIPlaceHolderTextView.h
//  GoldCleats
//
//  Created by Raju Gautam on 22/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
