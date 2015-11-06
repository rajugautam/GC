//
//  GCVideoProcessor.h
//  GoldCleats
//
//  Created by Raju Gautam on 10/29/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCVideoProcessorDelegate <NSObject>

@optional
-(void)processesdVideoURL:(NSURL *)finalURL;

@end
@interface GCVideoProcessor : NSObject

@property(nonatomic, assign) id<GCVideoProcessorDelegate> delegate;
@property(nonatomic, retain) UIView *overlayView;

- (void)processVideoAtPath:(NSURL*)url atScaleRate:(CGFloat)rate;
@end
