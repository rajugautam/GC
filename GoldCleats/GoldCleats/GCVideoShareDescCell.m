//
//  GCVideoShareDescCell.m
//  GoldCleats
//
//  Created by Raju Gautam on 22/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCVideoShareDescCell.h"
#import "UIPlaceHolderTextView.h"

@implementation GCVideoShareDescCell

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
        
        _videoDescription = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
        [_videoDescription setPlaceholder:@"Write a caption..."];
        [_videoDescription setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14]];
        [_videoDescription setDelegate:self];
        [self.contentView addSubview:_videoDescription];
        
        _videoThumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
            //_videoThumbnail.contentMode = UIViewContentModeScaleAspectFill;
            //[_videoThumbnail setImage:[UIImage imageNamed:@"video_placeholder"]];
        [_videoThumbnail setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [_videoThumbnail setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.contentView addSubview:_videoThumbnail];
        
        _playVideo = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playVideo setImage:[UIImage imageNamed:@"video_play_white"] forState:UIControlStateNormal];
        [_playVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_playVideo setUserInteractionEnabled:FALSE];
        [self.contentView addSubview:_playVideo];
        
        [self.videoThumbnail.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [[self.videoThumbnail layer] setCornerRadius:2.0f];
        [[self.videoThumbnail layer] setMasksToBounds:YES];
            //[self.imageView setBackgroundColor:[UIColor redColor]];
        
            //[self setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:231.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        
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
    
    [_videoThumbnail setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, CGRectGetMinY(frame) + 10.0f, 80, 80.0f)];
    
    [_playVideo setFrame:CGRectMake(_videoThumbnail.frame.origin.x + _videoThumbnail.frame.size.width / 2 - 8.0f, _videoThumbnail.frame.origin.y + _videoThumbnail.frame.size.height/ 2 - 8.0f, 15, 15)];
    
        //    CGSize size = [[_description text] sizeWithFont:[_description font]
        //                                       constrainedToSize:CGSizeMake(CGRectGetWidth(frame) - 10.0f, 17000.0f)
        //                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    [_videoDescription setFrame:CGRectMake(_videoThumbnail.frame.origin.x + _videoThumbnail.frame.size.width + 10, CGRectGetMinY(frame) + 10.0f, CGRectGetWidth(frame) - 90.0f, 80.0f)];
    
    [_view1 setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame) - 0.6f, CGRectGetWidth(frame), 0.6f)];
}

- (void)playVideo: (id)sender {
    [sender setSelected:![sender isSelected]];
    UITableView *tableView = [self tableView];
    if ([[tableView delegate] respondsToSelector:@selector(tableView:playButtonPressedAtIndex:)]) {
        [[tableView delegate] performSelector:@selector(tableView:playButtonPressedAtIndex:) withObject:tableView withObject:[tableView indexPathForCell:self]];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_callBack) {
        self.callBack(textView.text);
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
