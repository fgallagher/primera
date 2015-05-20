//
//  PRCoverScrollView.h
//  Audioplayer
//
//  Created by Paolo Rossignoli on 16/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SwipeView.h"

@protocol PRCoverScrollViewDelegate <NSObject>

@optional
- (void)playItemAtIndex:(NSUInteger)index;

@end

@interface PRCoverScrollView : SwipeView <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, assign) id<PRCoverScrollViewDelegate>delegateExtended;
@property (nonatomic, strong) MPMediaItemCollection *mediaItemCollection;

- (NSInteger) currentSongPlay:(MPMediaItem*)item;
- (void)didSelectItemAtIndex:(NSInteger)index;

@end
