//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DEFAULT_KEYWORD = @"GoldCleats";
static NSString *const UPLOAD_PLAYLIST = @"Replace me with the playlist ID you want to upload into";

static NSString *const kClientID = @"50340653270-v1jbte5ugdne96d8m1elnod9sr2tr6k8.apps.googleusercontent.com";
static NSString *const kClientSecret = @"";

static NSString *const kKeychainItemName = @"GoldCleats";

@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;
+ (NSString *)humanReadableFromYouTubeTime:(NSString *)youTubeTimeFormat;

+(NSString *)generateKeywordFromPlaylistId:(NSString *)playlistId;

@end
