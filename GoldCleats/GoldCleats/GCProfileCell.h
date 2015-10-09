//
//  GCProfileCell.h
//  GoldCleats
//
//  Created by Raju Gautam on 26/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCProfileCell : UITableViewCell
@property(nonatomic, retain) UIImageView *profilePic;
@property(nonatomic, retain) UIImageView *ivWatched;
@property(nonatomic, retain) UIImageView *ivFavorites;
@property(nonatomic, retain) UIImageView *ivShared;
@property(nonatomic, retain) UIImageView *ivUsername;

@property(nonatomic, retain) UILabel *watched;
@property(nonatomic, retain) UILabel *favorites;
@property(nonatomic, retain) UILabel *shared;

@property(nonatomic, retain) UILabel *username;


@end
