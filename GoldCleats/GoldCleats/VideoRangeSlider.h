//
//  VideoRangeSlider.h
//  GoldCleats
//
//  Created by Raju Gautam on 14/10/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "VideoSliderLeftView.h"
#import "VideoSliderRightView.h"
#import "VideoSliderBubble.h"


@protocol VideoRangeSliderDelegate;

@interface VideoRangeSlider : UIView
@property (nonatomic, weak) id <VideoRangeSliderDelegate> delegate;
@property (nonatomic) CGFloat leftPosition;
@property (nonatomic) CGFloat rightPosition;
@property (nonatomic, strong) UILabel *bubleText;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, assign) NSInteger maxGap;
@property (nonatomic, assign) NSInteger minGap;


- (id)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;
- (void)setPopoverBubbleSize: (CGFloat) width height:(CGFloat)height;


@end

@protocol VideoRangeSliderDelegate <NSObject>

@optional

- (void)videoRange:(VideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)videoRange:(VideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;


@end
