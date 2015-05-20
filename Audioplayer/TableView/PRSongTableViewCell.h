//
//  PRSongTableViewCell.h
//  Audioplayer
//
//  Created by Paolo Rossignoli on 06/03/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PRSongTableViewCell : UITableViewCell

@property (nonatomic, readwrite) MPMediaItem *mediaItem;

@end
