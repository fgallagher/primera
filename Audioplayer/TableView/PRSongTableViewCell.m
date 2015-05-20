//
//  PRSongTableViewCell.m
//  Audioplayer
//
//  Created by Paolo Rossignoli on 06/03/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRSongTableViewCell.h"

@implementation PRSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void) setMediaItem:(MPMediaItem *)mediaItem {
    if (_mediaItem != mediaItem) {
        _mediaItem = mediaItem;
        [self prepareUI];

    }
}

- (void) prepareUI {
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 50, 50);
   
    NSString* songTitle = [self.mediaItem valueForKey:MPMediaItemPropertyTitle];
    NSString* author = [self.mediaItem valueForKey:MPMediaItemPropertyAlbumArtist];
    NSString* album =[self.mediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    NSString* description = [NSString stringWithFormat:@"%@ - %@",author, album];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setText:songTitle];
    [self.detailTextLabel setText:description];
    [self.detailTextLabel setTextColor:[UIColor whiteColor]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    MPMediaItemArtwork *artwork = [self.mediaItem valueForKey:MPMediaItemPropertyArtwork];
    self.imageView.image = [artwork imageWithSize:CGSizeMake(50, 50)];
  
    if (self.imageView.image == nil) {
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder-artwork_thumb"];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, [UIScreen mainScreen].scale);
        [placeholderImage drawInRect:(CGRect) {0, 0, CGSizeMake(50, 50)}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.imageView.image = normalizedImage;

    }
    self.imageView.layer.masksToBounds = YES;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, 50, 50);
    [self.imageView setContentMode: UIViewContentModeScaleAspectFit];
    self.imageView.layer.cornerRadius = 25.f;
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
