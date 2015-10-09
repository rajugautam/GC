//
//  GCCustomCell.m
//  GoldCleats
//
//  Created by Raju Gautam on 26/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCCustomCell.h"

@implementation GCCustomCell

#pragma mark - Initilization Methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
            //[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        _seperator = [[UIView alloc] initWithFrame:CGRectZero];
        [_seperator setBackgroundColor:[UIColor colorWithRed:210.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
        [self.contentView addSubview:_seperator];

        
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        _name.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_name setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_name setText:@"Profile"];
        [_name setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_name];
        
        _score = [[UILabel alloc] initWithFrame:CGRectZero];
        _score.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_score setTextColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
        [_score setText:@"211"];
        [_score setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_score];
        
        
        _ivProfile = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_ivProfile setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_ivProfile];
        
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
    
    CGFloat heightOffset = CGRectGetHeight(frame) / 2 - 10;
    CGFloat widthOffset = 10.0f;
    [_ivProfile setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0, CGRectGetMinY(frame) + heightOffset, 18, 18.0f)];
    
    [_name setFrame:CGRectMake(widthOffset + 25.0f, CGRectGetMinY(frame) + heightOffset, 100.0f, 20.0f)];
    
    [_score setFrame:CGRectMake(CGRectGetWidth(frame) - 90.0f, CGRectGetMinY(frame) + heightOffset, 60.0f, 18.0f)];
    
    [_seperator setFrame:CGRectMake(CGRectGetMinX(frame) + 10.0f, CGRectGetMinY(frame), CGRectGetWidth(frame) - 10.0f, 0.6f)];
}


@end
