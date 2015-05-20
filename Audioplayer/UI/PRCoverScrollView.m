//
//  PRCoverScrollView.m
//  Audioplayer
//
//  Created by Paolo Rossignoli on 06/03/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRCoverScrollView.h"

#define IMAGE_ALPHA             0.5
#define IMAGE_FOR_PAGE          4

@interface PRCoverScrollView()

@property (nonatomic, strong) NSMutableArray *imagesViewArray;
@property (nonatomic, strong) UIImageView *tempImageView;

@end



@implementation PRCoverScrollView


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.clipsToBounds = NO;
    [self setDelegate:self];
    [self setDataSource:self];
    [self setItemsPerPage:4];
    [self setPagingEnabled:YES];
    [self setTruncateFinalPage:NO];
    [self setAlignment:SwipeViewAlignmentCenter];
    self.wrapEnabled = NO;
    self.defersItemViewLoading = NO;
}

#pragma mark -- SwipeView Datasource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    NSLog(@"ITEMS %lu", (unsigned long)[self.mediaItemCollection.items count]);
    NSArray* items = self.mediaItemCollection.items;
    return (items == nil)?0:[items count];
}

#pragma mark -- SwipeView Delegate
- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    CGSize imageSize = CGSizeMake(80, 70);
    return imageSize;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    
    
    CGRect viewFrame = CGRectMake(0, 0, 80, 70);
    CGRect imageFrame = CGRectMake(5, 0, 70, 70);
    CGSize imageSize = CGSizeMake(70, 70);

    if (view == nil) {
        view = [[UIView alloc] initWithFrame:viewFrame];
    }
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 35;//8.f;
    [imageView setAlpha:IMAGE_ALPHA];
    MPMediaItem *item  = [[self.mediaItemCollection items] objectAtIndex:index];
    MPMediaItemArtwork *artwork = [item valueForProperty: MPMediaItemPropertyArtwork];
    
    UIImage *artworkImage =[artwork imageWithSize:imageSize];
    //NSLog(@"artworkImage %@",artworkImage);
    
    if (artworkImage) {
        imageView.image = [self imageFilterNormal:artworkImage];
    } else {
        imageView.image = [self imageFilterNormal:[UIImage imageNamed: @"placeholder-artwork"]];
    }
    
    
    //NSLog(@"INDEX %li",(long)index);
    
    view.tag = index;
    
    [view addSubview:imageView];
    
    return view;
}

#pragma mark --
#pragma mark -- Setting vars
- (void) setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection {
    if (_mediaItemCollection != mediaItemCollection) {
        _mediaItemCollection = mediaItemCollection;
    }
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
}

- (NSInteger) currentSongPlay:(MPMediaItem*)item {
    NSInteger index = 0;
    NSArray *items = [_mediaItemCollection items];
    int i = 0;
    for (MPMediaItem *oneItem in items) {
        
        if ([oneItem isEqual:item]) {
            //NSLog(@"item name %@",[item valueForKey:MPMediaItemPropertyTitle]);
            index = i;
        }
        i++;
    }
    return index;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    if (self.tempImageView) {
        [self.tempImageView setAlpha:IMAGE_ALPHA];
        self.tempImageView.layer.borderWidth = 0;
        self.tempImageView.layer.borderColor = nil;
    }
    
    UIImageView *currentImageView = [[self itemViewAtIndex:index] subviews][0];//[[swipeView.currentItemView. viewWithTag:index] subviews][0];
    [currentImageView setAlpha:1];//.image = [self imageFilterSelect:currentImageView.image];
    currentImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    currentImageView.layer.borderWidth = 2;

    self.tempImageView = currentImageView;
}

#pragma mark --
#pragma mark -- DELEGATE
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    //NSLog(@"SELECT %li",(long)index);
    [self didSelectItemAtIndex:index];
    if (self.delegateExtended && [self.delegateExtended respondsToSelector:@selector(playItemAtIndex:)]) {
        [self.delegateExtended playItemAtIndex:index];
    }
}
/*
 - (BOOL)swipeView:(SwipeView *)swipeView shouldSelectItemAtIndex:(NSInteger)index {
 return YES;
 }
 */






#pragma mark -- Image Filter
#pragma mark -- Normal
- (UIImage*) imageFilterNormal:(UIImage*)image {
    CIImage *_inputImage = [CIImage imageWithCGImage:[image CGImage]];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [filter setValue:_inputImage forKey:kCIInputImageKey];
    UIImage *outputImage = [UIImage imageWithCIImage:filter.outputImage];
    return outputImage;
}
#pragma mark -- Select
- (UIImage*) imageFilterSelect:(UIImage*)image {
    CIImage *_inputImage = [CIImage imageWithCGImage:[image CGImage]];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
    [filter setValue:_inputImage forKey:kCIInputImageKey];
    UIImage *outputImage = [UIImage imageWithCIImage:filter.outputImage];
    return outputImage;
}


@end
