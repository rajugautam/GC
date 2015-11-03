//
//  GCPlayerView.m
//  GoldCleats
//
//  Created by Raju Gautam on 11/3/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

#import "GCPlayerView.h"

@implementation GCPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
