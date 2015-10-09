//
//  HomeViewCell.m
//  GoldCleats
//
//  Created by Raju Gautam on 21/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "HomeViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomeViewCell

@synthesize description = _description;

#pragma mark - Initilization Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
            //[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        _view1 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view1 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view1];
        
        _view2 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view2 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view2];
        
        _view3 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view3 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view3];
        
        _view4 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view4 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view4];
        
        _view5 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view5 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view5];
        
        _view6 = [[UIView alloc] initWithFrame:CGRectZero];
        [_view6 setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_view6];
        
        _likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_likeButton setImage:[UIImage imageNamed:@"like_green"] forState:UIControlStateNormal];
//        [_likeButton setImage:[UIImage imageNamed:@"like_golden"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_likeButton];
        
        _commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setImage:[UIImage imageNamed:@"comments_green"] forState:UIControlStateNormal];
//        [_commentButton setImage:[UIImage imageNamed:@"comments_golden"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_commentButton];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shareButton setImage:[UIImage imageNamed:@"share_green"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareVideo:) forControlEvents:UIControlEventTouchUpInside];
            //[_shareButton setImage:[UIImage imageNamed:@"share_golden"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_shareButton];
        
        _description = [[UILabel alloc] initWithFrame:CGRectZero];
        _description.numberOfLines = 0;
        _description.lineBreakMode = NSLineBreakByWordWrapping;
        _description.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        [self.contentView addSubview:_description];
        
        _videoThumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
            //_videoThumbnail.contentMode = UIViewContentModeScaleAspectFill;
            //[_videoThumbnail setImage:[UIImage imageNamed:@"video_placeholder"]];
        [_videoThumbnail setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [_videoThumbnail setContentMode:UIViewContentModeScaleAspectFill];

        [self.contentView addSubview:_videoThumbnail];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playButton setImage:[UIImage imageNamed:@"video_play_white"] forState:UIControlStateNormal];
        [_playButton setUserInteractionEnabled:FALSE];
        [self.contentView addSubview:_playButton];
        
        [self.videoThumbnail.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [[self.videoThumbnail layer] setCornerRadius:2.0f];
        [[self.videoThumbnail layer] setMasksToBounds:YES];
            //[self.imageView setBackgroundColor:[UIColor redColor]];
        
            //[self setBackgroundColor:[UIColor lightGrayColor]];
        
//        [self.description.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [self.description.layer setCornerRadius:2.0f];
//        [self.description.layer setMasksToBounds:YES];
//        [self.description.layer setBorderWidth:1.5f];
        
    }
    return self;
}


#pragma mark - Layout Configuration Views
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectInset([self bounds], 0.0f, 0.0f);
//    frame.size.height -= 1.0f;
    [self.backgroundView setFrame:frame];
    
    [_videoThumbnail setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, CGRectGetMinY(frame) + 5.0f, CGRectGetWidth(frame) - 20, 170.0f)];
    
    [_playButton setFrame:CGRectMake(_videoThumbnail.frame.origin.x + _videoThumbnail.frame.size.width / 2 - 18.0f, _videoThumbnail.frame.origin.y + _videoThumbnail.frame.size.height/ 2 - 18.0f, 42, 42)];
    
    CGSize size = [[_description text] sizeWithFont:[_description font]
                                       constrainedToSize:CGSizeMake(CGRectGetWidth(frame) - 10.0f, 17000.0f)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    [_description setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, _videoThumbnail.frame.origin.y + _videoThumbnail.frame.size.height + 5.0f, CGRectGetWidth(frame) - 20, size.height)];
    
    [_view1 setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, _description.frame.origin.y + _description.frame.size.height + 5.0f, CGRectGetWidth(frame) - 20, 2.0f)];
    
    [_view5 setFrame:CGRectMake(CGRectGetMinX(frame) + 10, _view1.frame.origin.y + _view1.frame.size.height, 1.5f, 37.0f)];
    
    [_likeButton setFrame:CGRectMake(CGRectGetMinX(frame) + 10, _view1.frame.origin.y + _view1.frame.size.height + 5.0f, CGRectGetWidth(frame) / 3, 25.0f)];
    
    [_view2 setFrame:CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width, _description.frame.origin.y + _description.frame.size.height + 5.0f, 1.5f, 37.0f)];
    
    [_commentButton setFrame:CGRectMake(_view2.frame.origin.x + _view2.frame.size.width, _view1.frame.origin.y + _view1.frame.size.height + 5.0f, CGRectGetWidth(frame) / 3, 25.0f)];
    
    [_view3 setFrame:CGRectMake(_commentButton.frame.origin.x + _commentButton.frame.size.width, _description.frame.origin.y + _description.frame.size.height + 5.0f, 1.5f, 37.0f)];
    
    [_shareButton setFrame:CGRectMake(_view3.frame.origin.x + _view3.frame.size.width, _view1.frame.origin.y + _view1.frame.size.height + 5.0f, CGRectGetWidth(frame) / 3, 25.0f)];
    
    [_view6 setFrame:CGRectMake(CGRectGetWidth(frame) - 10.0f, _view1.frame.origin.y + _view1.frame.size.height, 1.5f, 37.0f)];
    
    [_view4 setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, _shareButton.frame.origin.y + _shareButton.frame.size.height + 5.0f, CGRectGetWidth(frame) - 20, 2.0f)];
    
}

- (void)shareVideo: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:shareButtonPressedAtIndex:)]) {
        [[tableView delegate] performSelector:@selector(tableView:shareButtonPressedAtIndex:) withObject:tableView withObject:[tableView indexPathForCell:self]];
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
