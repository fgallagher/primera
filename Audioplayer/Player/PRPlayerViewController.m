//
//  AZPlayerViewController.m
//  WellRun
//
//  Created by Paolo Rossignoli on 07/03/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRPlayerViewController.h"

#import "PRArtwork.h"
#import "PRSeekBar.h"
#import "PRCoverScrollView.h"

#import "GVMusicPlayerController.h"
#import "NSString+TimeToString.h"
#import "EFCircularSlider.h"
#import "FXBlurView.h"
#import "PRAppDelegate.h"

@interface PRPlayerViewController () <GVMusicPlayerControllerDelegate, UIScrollViewDelegate, PRCoverScrollViewDelegate>

//Interface
@property (nonatomic, weak) IBOutlet UIImageView *artworkBackground;
@property (nonatomic, strong) FXBlurView *artworkBackgroundBlur;
@property (nonatomic, weak) IBOutlet PRArtwork *artwork;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *elapsedPlayTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet PRSeekBar *timeSlider;
//Buttons
@property (weak, nonatomic) IBOutlet UIButton *togglePlayPause;
@property (weak, nonatomic) IBOutlet UIButton *nextTrackButton;
@property (weak, nonatomic) IBOutlet UIButton *previousTrackButton;
@property (weak, nonatomic) IBOutlet UIView *playControllerV;

@property (nonatomic, strong) PRCoverScrollView *coverScrollView;
//Function
@property (nonatomic, strong) NSTimer *timer;
@property BOOL panningProgress;
@property BOOL panningVolume;

@end



@implementation PRPlayerViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Primera";
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timedJob) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewWillAppear:(BOOL)animated {
    // NOTE: add and remove the GVMusicPlayerController delegate in
    // the viewWillAppear / viewDidDisappear methods, not in the
    // viewDidLoad / viewDidUnload methods - it will result in dangling
    // objects in memory.
    [super viewWillAppear:animated];
    [[GVMusicPlayerController sharedInstance] addDelegate:self];
    //[self.navigationController setNavigationBarHidden:YES];
//    CGFloat playControllerX = self.playControllerV.frame.origin.x;
//    CGFloat previousTrackButtonX = self.previousTrackButton.frame.origin.x;
    [PRAppDelegate storyBoradAutoLay:self.view];
    CGFloat height = self.artworkBackground.frame.size.height;
    CGFloat width = self.artworkBackground.frame.size.width;
    CGFloat distance = abs(height-width)/2;
    CGSize size = CGSizeMake(MIN(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width), MIN(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width));
    if (((PRAppDelegate*)[UIApplication sharedApplication].delegate).autoSizeScaleX>1||((PRAppDelegate*)[UIApplication sharedApplication].delegate).autoSizeScaleY>1) {
        size = CGSizeMake(MAX(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width), MAX(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width));
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.artworkBackground.image drawInRect:(CGRect) {0, 0, size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.artworkBackground.image = normalizedImage;
    [self.artworkBackground sizeToFit];
    CGFloat radius = MIN(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width)/2;
    if (((PRAppDelegate*)[UIApplication sharedApplication].delegate).autoSizeScaleX>1||((PRAppDelegate*)[UIApplication sharedApplication].delegate).autoSizeScaleY>1) {
        radius = MAX(self.artworkBackground.frame.size.height, self.artworkBackground.frame.size.width)/2;

    }
    [self.artworkBackground.layer setCornerRadius:radius];
    if (width-height>0) {
          self.artworkBackground.frame = CGRectMake(self.artworkBackground.frame.origin.x+distance, self.artworkBackground.frame.origin.y, self.artworkBackground.frame.size.width, self.artworkBackground.frame.size.height);
    }
    if (height-width>0) {
             self.artworkBackground.frame = CGRectMake(self.artworkBackground.frame.origin.x-distance, self.artworkBackground.frame.origin.y, self.artworkBackground.frame.size.width, self.artworkBackground.frame.size.height);
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [[GVMusicPlayerController sharedInstance] removeDelegate:self];
    [super viewDidDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
}
/*
 -(UIStatusBarStyle)preferredStatusBarStyle{
 return UIStatusBarStyleLightContent;
 }
 */
#pragma mark - Catch remote control events, forward to the music player

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    [[GVMusicPlayerController sharedInstance] remoteControlReceivedWithEvent:receivedEvent];
}

- (void)timedJob {
    if (!self.panningProgress) {
        self.timeSlider.currentValue = [GVMusicPlayerController sharedInstance].currentPlaybackTime;
        self.elapsedPlayTimeLabel.text = [NSString stringFromTime:[GVMusicPlayerController sharedInstance].currentPlaybackTime];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark -- Setto le variabili
- (void) setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection {
    if (_mediaItemCollection != mediaItemCollection) {
        _mediaItemCollection = mediaItemCollection;
        [self activeScrollView];
        [[GVMusicPlayerController sharedInstance] setQueueWithItemCollection:_mediaItemCollection];
    }
}
- (void) setMediaItem:(MPMediaItem *)mediaItem {
    if (_mediaItem != mediaItem) {
        _mediaItem = mediaItem;
        [[GVMusicPlayerController sharedInstance] playItem:_mediaItem];
        [[GVMusicPlayerController sharedInstance] play];
    }
}

#pragma mark - IBActions
#pragma mark -- Bottoni

- (IBAction)playButtonPressed {
    if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
        [[GVMusicPlayerController sharedInstance] pause];
    } else {
        [[GVMusicPlayerController sharedInstance] play];
    }
}

- (IBAction)prevButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToPreviousItem];
}

- (IBAction)nextButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToNextItem];
}

#pragma mark -- Slider
- (IBAction)progressChanged:(EFCircularSlider *)sender {
    // While dragging the progress slider around, we change the time label,
    // but we're not actually changing the playback time yet.
    self.panningProgress = YES;
    self.elapsedPlayTimeLabel.text = [NSString stringFromTime:sender.currentValue];
}
- (IBAction)progressEnd {
    // Only when dragging is done, we change the playback time.
    [GVMusicPlayerController sharedInstance].currentPlaybackTime = self.timeSlider.currentValue;
    self.panningProgress = NO;
}

#pragma mark - AVMusicPlayerControllerDelegate

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.togglePlayPause.selected = (playbackState == MPMusicPlaybackStatePlaying);
    //NSLog(@"self.togglePlayPause.selected %i",self.togglePlayPause.selected);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    self.artworkBackground.contentMode = UIViewContentModeScaleAspectFill;
    if (!nowPlayingItem) {
        return;
    }
    // Time labels
    NSTimeInterval trackLength = [[nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.durationLabel.text = [NSString stringFromTime:trackLength];
    self.timeSlider.currentValue = 0;
    self.timeSlider.maximumValue = trackLength;
    [self.timeSlider setupUI];
    
    // Labels
    self.titleLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.authorLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage =[artwork imageWithSize:self.artwork.bounds.size];
    
    if (artworkImage) {
        self.artworkBackground.image = artworkImage;
        if (REMOVE_BLUR_EFFECTS) {
            self.artwork.image =  artworkImage;
        } else {
            self.artwork.image =  [artworkImage blurredImageWithRadius:BLUR_RADIUS iterations:1 tintColor:[UIColor clearColor]];
        }
    } else {
        self.artworkBackground.image = [UIImage imageNamed: @"placeholder-artwork"];
        if (REMOVE_BLUR_EFFECTS) {
            self.artwork.image = [UIImage imageNamed: @"placeholder-artwork"];
        } else {
            self.artwork.image = [[UIImage imageNamed: @"placeholder-artwork"]  blurredImageWithRadius:BLUR_RADIUS iterations:1 tintColor:[UIColor clearColor]];
        }
    }
    
    
    //NSLog(@"Proof that this code is being called, even in the background!");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
    // Background work
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            //ScrollView
            float page = round(musicPlayer.indexOfNowPlayingItem / 4);
            [self.coverScrollView setCurrentPage:page];
            [self.coverScrollView didSelectItemAtIndex:musicPlayer.indexOfNowPlayingItem];
        });
    });
    
    self.nextTrackButton.hidden = NO;
    self.previousTrackButton.hidden = NO;
    if (self.mediaItemCollection.items.count < 1){
        self.nextTrackButton.hidden = YES;
        self.previousTrackButton.hidden = YES;
    }
    if ([self.mediaItemCollection.items.lastObject isEqual:nowPlayingItem]) {
        self.nextTrackButton.hidden = YES;
    }
    if ([self.mediaItemCollection.items.firstObject isEqual:nowPlayingItem]) {
        self.previousTrackButton.hidden = YES;
    }
}




- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer endOfQueueReached:(MPMediaItem *)lastTrack {
    NSLog(@"End of queue, but last track was %@", [lastTrack valueForProperty:MPMediaItemPropertyTitle]);
}

- (void) activeScrollView {
    self.coverScrollView = [[PRCoverScrollView alloc] initWithFrame:CGRectMake(0,480, 320, 88)];
    [self.coverScrollView setMediaItemCollection:self.mediaItemCollection];
    [self.coverScrollView setDelegateExtended:self];
    [self.view addSubview:self.coverScrollView];
    
    //[self.coverScrollView loadImagesForPage:1];
}

#pragma marl - CoverScrollView Delegate
- (void) playItemAtIndex:(NSUInteger)index {
    [[GVMusicPlayerController sharedInstance] playItemAtIndex:index];
    [[GVMusicPlayerController sharedInstance] play];
}


@end
