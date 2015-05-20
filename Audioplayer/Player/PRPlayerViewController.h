//
//  PRViewController.h
//  Audioplayer
//
//  Created by Paolo Rossignoli on 11/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PRPlayerViewController : UIViewController

@property (nonatomic, strong) MPMediaItemCollection *mediaItemCollection;
@property (nonatomic, strong) MPMediaItem *mediaItem;

@end
