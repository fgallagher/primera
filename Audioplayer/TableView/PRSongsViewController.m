//
//  PRTableViewController.m
//  Audioplayer
//
//  Created by Paolo Rossignoli on 24/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRSongsViewController.h"
#import <NAKPlaybackIndicatorView/NAKPlaybackIndicatorView.h>
#import "PRSongTableViewCell.h"
#import "GVMusicPlayerController.h"
#import "FXBlurView.h"
#import "PRPlayerViewController.h"
#import "PRAppDelegate.h"

@interface PRSongsViewController () <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate>
{
    BOOL loaded;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *artworkBackground;
@property (nonatomic, strong) MPMediaItem* mediaItem;
@property (nonatomic, strong) FXBlurView* artworkBackgroundBlur;

@end

@implementation PRSongsViewController

#pragma mark --
#pragma mark -- Setto le variabili

- (void) setMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection {
    if (_mediaItemCollection != mediaItemCollection) {
        _mediaItemCollection = mediaItemCollection;
        /*
        */
        //[self.tableView reloadData];
    }
}

- (void)prepareUI
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.title = @"Primera";
    [self.tableView setRowHeight:60.];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
    
    [self.artworkBackground setContentMode:UIViewContentModeScaleAspectFill];
    MPMediaItem*mediaItem = [self.mediaItemCollection.items objectAtIndex:0];
    MPMediaItemArtwork *artwork = [mediaItem valueForKey:MPMediaItemPropertyArtwork];
    if (REMOVE_BLUR_EFFECTS) {
        self.artworkBackground.image = [artwork imageWithSize:CGSizeMake(640.0f, 640.0f)];
    }else {
        self.artworkBackground.image = [[artwork imageWithSize:CGSizeMake(640.0f, 640.0f)] blurredImageWithRadius:BLUR_RADIUS iterations:1 tintColor:[UIColor clearColor]];
    }
    if (self.artworkBackground.image == nil) {
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder-artwork"];
        if (REMOVE_BLUR_EFFECTS) {
            self.artworkBackground.image = placeholderImage;
        } else {
            self.artworkBackground.image = [placeholderImage blurredImageWithRadius:BLUR_RADIUS iterations:1 tintColor:[UIColor clearColor]];
        }
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- Open Media Collection
- (IBAction)openMediaPickerController:(id)sender{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.showsCloudItems = NO;
    mediaPicker.prompt = @"Select songs to anlized...";
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   // NSLog(@"self.mediaItemCollection.items.count %i",self.mediaItemCollection.items.count);
    return self.mediaItemCollection.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    PRSongTableViewCell *cell = (PRSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PRSongTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.mediaItem = [self.mediaItemCollection.items objectAtIndex:indexPath.row];
    
    NSLog(@"cell.mediaItem %@",cell.mediaItem);
    NSLog(@"cell.mediaItem %@",[cell.mediaItem valueForKey:MPMediaItemPropertyTitle]);
    
    NAKPlaybackIndicatorView *indicator = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectZero];
    [cell.imageView addSubview:indicator];
    [indicator sizeToFit];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"pushPlayerController"]){
        NSLog(@"Return to leak spotter segue...");
        PRPlayerViewController *controller = (PRPlayerViewController *)[segue destinationViewController];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [controller setMediaItemCollection:self.mediaItemCollection];
        [controller setMediaItem:self.mediaItem];
    }
}

#pragma mark -- DELEGATE
#pragma mark -- TableView Songs 
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.mediaItem = [self.mediaItemCollection.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"pushPlayerController" sender:self];
}


#pragma mark -- MPMediaPickerController
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) collection {
    
    NSMutableArray*tempCollection = [NSMutableArray arrayWithArray:self.mediaItemCollection.items];
    [tempCollection addObjectsFromArray:collection.items];
    NSLog(@"tempCollection %@",tempCollection);
    self.mediaItemCollection = nil;
    self.mediaItemCollection = [MPMediaItemCollection collectionWithItems:tempCollection];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat x = self.tableView.frame.origin.x;
    CGFloat y = self.tableView.frame.origin.y;
    if (!loaded) {
        loaded = YES;
        [PRAppDelegate storyBoradAutoLay:self.view];
    }
    self.tableView.frame = CGRectMake(x, y, self.tableView.frame.size.width, self.tableView.frame.size.width);
}


@end
