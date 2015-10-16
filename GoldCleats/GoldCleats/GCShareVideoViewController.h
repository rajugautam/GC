//
//  GCShareVideoViewController.h
//  GoldCleats
//
//  Created by Raju Gautam on 21/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouTubeUploadVideo.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class VideoData;

typedef NS_ENUM(NSInteger, MediaType) {
    KTypeVideo,
    kTypeImage
};

@interface GCShareVideoViewController : UITableViewController<YouTubeUploadVideoDelegate, UITextViewDelegate, FBSDKSharingDelegate>

@property(nonatomic, retain)VideoData *videoData;
@property(nonatomic, strong) NSURL *videoUrl;
@property(nonatomic, strong) NSURL *referenceUrl;
@property(nonatomic, strong) YouTubeUploadVideo *uploadVideo;
//@property(nonatomic, retain) GTLServiceYouTube *youtubeService;
@property(nonatomic, readwrite) BOOL freshVideo;
@property(nonatomic, retain) UIImage *thumbnail;
@property(nonatomic, assign) enum MediaType mediaType;

@property(nonatomic, retain) UIView *subView;
@property(nonatomic, retain) NSString *videoDescription;

@property(nonatomic, retain) MPMoviePlayerController *player;

@end
