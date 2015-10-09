//
//  GCVideoShareDescCell.h
//  GoldCleats
//
//  Created by Raju Gautam on 22/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPlaceHolderTextView;

typedef void (^GCVideoShareDescCallBack)(NSString *string);

@interface GCVideoShareDescCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, retain)UIImageView *videoThumbnail;
@property (nonatomic, retain)UIPlaceHolderTextView *videoDescription;
@property (nonatomic, retain)UIButton *playVideo;
@property (nonatomic, copy) GCVideoShareDescCallBack callBack;

@property (nonatomic, retain) UIView *view1;

@end
