//
//  GCShareCell.m
//  GoldCleats
//
//  Created by Raju Gautam on 22/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCShareCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GCShareCell

#pragma mark - Initilization Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
            //[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        _view1 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view1 setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view1];
        
        _view2 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view2 setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view2];
        
        _view3 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view3 setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view3];
        
        _view4 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view4 setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view4];
        
        _youtube = [[UIButton alloc] initWithFrame:CGRectZero];
        [_youtube setImage:[UIImage imageNamed:@"ic_youtube"] forState:UIControlStateNormal];
        [_youtube setTitle:@"YouTube  " forState:UIControlStateNormal];
        [_youtube setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(_youtube.frame)-10, 0, 0)];
        [_youtube.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
        [_youtube setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_youtube addTarget:self action:@selector(shareVideoOnYoutube:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_youtube];
        
        _facebook = [[UIButton alloc] initWithFrame:CGRectZero];
        [_facebook setImage:[UIImage imageNamed:@"ic_facebook"] forState:UIControlStateNormal];
        [_facebook setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(_youtube.frame)-10, 0, 0)];
        [_facebook.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
        [_facebook setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_facebook addTarget:self action:@selector(shareVideoOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [_facebook setTitle:@"Facebook " forState:UIControlStateNormal];
        [self.contentView addSubview:_facebook];
        
        _twitter = [[UIButton alloc] initWithFrame:CGRectZero];
        [_twitter setImage:[UIImage imageNamed:@"ic_twitter"] forState:UIControlStateNormal];
        [_twitter setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(_youtube.frame)-10, 0, 0)];
        [_twitter.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
        [_twitter setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_twitter addTarget:self action:@selector(shareVideoOnTwitter:) forControlEvents:UIControlEventTouchUpInside];
        [_twitter setTitle:@"Twitter   " forState:UIControlStateNormal];
        [self.contentView addSubview:_twitter];
        
        _instagram = [[UIButton alloc] initWithFrame:CGRectZero];
        [_instagram setImage:[UIImage imageNamed:@"ic_instagram"] forState:UIControlStateNormal];
        [_instagram setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(_youtube.frame)-10, 0, 0)];
        [_instagram.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15]];
        [_instagram setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_instagram addTarget:self action:@selector(shareVideoOnInstagram:) forControlEvents:UIControlEventTouchUpInside];
        [_instagram setTitle:@"Instagram" forState:UIControlStateNormal];
        [self.contentView addSubview:_instagram];
        
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [[self layer] setCornerRadius:1.0f];
        [[self layer] setMasksToBounds:YES];
        
            //[self setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];

    }
    return self;
}


#pragma mark - Layout Configuration Views
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectInset([self bounds], 0.0f, 0.0f);
        //    frame.size.height -= 1.0f;
    [self.backgroundView setFrame:frame];
    
    [_view1 setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), 0.6f)];
    
    [_instagram setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 1.0f, CGRectGetWidth(frame) / 2, 40.0f)];
    
    [_facebook setFrame:CGRectMake(CGRectGetWidth(frame)/2 + 2.0f, CGRectGetMinY(frame) + 1.0f, CGRectGetWidth(frame)/2, 40.0f)];
    
    [_view2 setFrame:CGRectMake(CGRectGetWidth(frame)/2 + 0.6f, CGRectGetMinY(frame), 0.6f, CGRectGetHeight(frame))];
    
    [_view3 setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame) / 2 + 0.6, CGRectGetWidth(frame), 0.6f)];
    
    [_twitter setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame) / 2 + 1.6f, CGRectGetWidth(frame)/2, 40.0f)];
    
    [_youtube setFrame:CGRectMake(CGRectGetWidth(frame)/2 + 2.0f, CGRectGetHeight(frame) / 2 + 1.0f, CGRectGetWidth(frame)/2, 40.0f)];

    [_view4 setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame) - 0.6f, CGRectGetWidth(frame), 0.6f)];
}

- (void)shareVideoOnYoutube: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:youtubeBtnPressed:)]) {
        [[tableView delegate] performSelector:@selector(tableView:youtubeBtnPressed:) withObject:tableView withObject:[tableView indexPathForCell:self]];
    }
    
}

- (void)shareVideoOnInstagram: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:instagramBtnPressed:)]) {
        [[tableView delegate] performSelector:@selector(tableView:instagramBtnPressed:) withObject:tableView withObject:[tableView indexPathForCell:self]];
    }
    
}


- (void)shareVideoOnTwitter: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:twitterBtnPressed:)]) {
        [[tableView delegate] performSelector:@selector(tableView:twitterBtnPressed:) withObject:tableView withObject:[tableView indexPathForCell:self]];
    }
    
}

- (void)shareVideoOnFacebook: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:facebookBtnPressed:)]) {
        [[tableView delegate] performSelector:@selector(tableView:facebookBtnPressed:) withObject:tableView withObject:[tableView indexPathForCell:self]];
    }
    
}



#pragma mark - Action Methods
- (UITableView *)tableView {
    UITableView *tableView = (id)[self superview];
    if (FLDeviceIsUIKit7()) {
        tableView = (id)[tableView superview];
    }
    return tableView;
}

@end
