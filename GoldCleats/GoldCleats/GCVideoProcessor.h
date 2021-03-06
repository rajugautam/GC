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
-(void)processesdVideoURL:(NSURL *)finalURL isSavedToPhotoLibrary:(BOOL)flag;

@end
@interface GCVideoProcessor : NSObject

@property(nonatomic, assign) id<GCVideoProcessorDelegate> delegate;
@property(nonatomic, retain) UIView *overlayView;

- (void)processVideoAtPath:(NSURL*)url atScaleRate:(CGFloat)rate;
- (void)mergeVideoAtPath:(NSURL*)video1 withVideoAtPath:(NSURL*)video2;
- (void)exportVideoWithOverlayForURL:(NSURL*) url withPointsArray:(NSArray *)points circleRadius:(CGFloat)circleRadius startPlaybackTime:(NSTimeInterval)beginTime;
//- (UIImage *) imageWithView:(UIView *)view;

@end
