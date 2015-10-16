//
//  AppDelegate.h
//  GoldCleats
//
//  Created by Raju Gautam on 19/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLYouTube.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;


@end

