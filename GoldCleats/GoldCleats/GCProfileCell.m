//
//  GCProfileCell.m
//  GoldCleats
//
//  Created by Raju Gautam on 26/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCProfileCell.h"

@implementation GCProfileCell


#pragma mark - Initilization Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
            //[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        _watched = [[UILabel alloc] initWithFrame:CGRectZero];
        _watched.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_watched setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_watched setText:@"309"];
        [_watched setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_watched];

        _shared = [[UILabel alloc] initWithFrame:CGRectZero];
        _shared.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_shared setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_shared setText:@"211"];
        [_shared setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_shared];

        _favorites = [[UILabel alloc] initWithFrame:CGRectZero];
        _favorites.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_favorites setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_favorites setText:@"321"];
        [_favorites setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_favorites];

        _username = [[UILabel alloc] initWithFrame:CGRectZero];
        _username.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        //[_username setTextColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
        [_username setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_username setText:@"Chuck Norris"];
        [_username setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_username];
        
        _profilePic = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_profilePic setImage:[UIImage imageNamed:@"ic_profile_placeholder"]];
        [_profilePic setContentMode:UIViewContentModeScaleAspectFit];
        [_profilePic.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [[_profilePic layer] setCornerRadius:2.0f];
        [[_profilePic layer] setMasksToBounds:YES];
        
        [self.contentView addSubview:_profilePic];

        
        _ivWatched = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_ivWatched setContentMode:UIViewContentModeScaleAspectFit];
        [_ivWatched setImage:[UIImage imageNamed:@"ic_watched"]];
        [self.contentView addSubview:_ivWatched];
        
        _ivShared = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_ivShared setContentMode:UIViewContentModeScaleAspectFit];
        [_ivShared setImage:[UIImage imageNamed:@"ic_share"]];
        [self.contentView addSubview:_ivShared];
        
        _ivFavorites = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_ivFavorites setContentMode:UIViewContentModeScaleAspectFit];
        [_ivFavorites setImage:[UIImage imageNamed:@"ic_favorite"]];
        [self.contentView addSubview:_ivFavorites];
        
        _ivUsername = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_ivUsername setContentMode:UIViewContentModeScaleAspectFit];
        [_ivUsername setImage:[UIImage imageNamed:@"ic_flag"]];
        [self.contentView addSubview:_ivUsername];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


#pragma mark - Layout Configuration Views
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectInset([self bounds], 0.0f, 0.0f);
        //    frame.size.height -= 1.0f;
    [self.backgroundView setFrame:frame];
    
    CGFloat heightOffset = 10.0f;
    CGFloat widthOffset = 10.0f;
    [_profilePic setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, CGRectGetMinY(frame) + heightOffset, 100, 100.0f)];
    
    widthOffset += _profilePic.frame.size.width;
    
    [_ivWatched setFrame:CGRectMake(widthOffset + 15.0f, CGRectGetMinY(frame) + heightOffset, 18.0f, 18.0f)];
    
    [_watched setFrame:CGRectMake(CGRectGetWidth(frame) - 90.0f, CGRectGetMinY(frame) + heightOffset, 60.0f, 18.0f)];
    
    heightOffset += 40.0f;
    
    [_ivShared setFrame:CGRectMake(widthOffset + 15.0f, CGRectGetMinY(frame) + heightOffset, 18.0f, 18.0f)];
    
    [_shared setFrame:CGRectMake(CGRectGetWidth(frame) - 90.0f, CGRectGetMinY(frame) + heightOffset, 60.0f, 18.0f)];
    
    heightOffset += 40.0f;
    
    [_ivFavorites setFrame:CGRectMake(widthOffset + 15.0f, CGRectGetMinY(frame) + heightOffset, 18.0f, 18.0f)];
    
    [_favorites setFrame:CGRectMake(CGRectGetWidth(frame) - 90.0f, CGRectGetMinY(frame) + heightOffset, 60.0f, 18.0f)];
    
    heightOffset += 30.0f;
    [_ivUsername setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, _profilePic.frame.origin.y + _profilePic.frame.size.height + 11.0f, 12.0f, 12.0f)];
    
    [_username setFrame:CGRectMake(_ivUsername.frame.size.width + 20.0, _profilePic.frame.origin.y + _profilePic.frame.size.height + 8.0f, CGRectGetWidth(frame) - 50, 18.0f)];
    
}


@end
