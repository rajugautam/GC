//
//  HomeViewCell.h
//  GoldCleats
//
//  Created by Raju Gautam on 21/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewCell : UITableViewCell

@property(nonatomic, strong)UIImageView *videoThumbnail;
@property(nonatomic, strong)UILabel *description;
@property(nonatomic, strong)UIButton *likeButton;
@property(nonatomic, strong)UIButton *commentButton;
@property(nonatomic, strong)UIButton *shareButton;

@property(nonatomic, strong)UIButton *playButton;

@property(nonatomic, strong)UIView *view1;
@property(nonatomic, strong)UIView *view2;
@property(nonatomic, strong)UIView *view3;
@property(nonatomic, strong)UIView *view4;
@property(nonatomic, strong)UIView *view5;
@property(nonatomic, strong)UIView *view6;
@end
