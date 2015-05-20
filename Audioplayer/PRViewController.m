//
//  PRViewController.m
//  GetTheBeat
//
//  Created by Paolo Rossignoli on 08/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRViewController.h"
#import "PRSongsViewController.h"
#import "PRButton.h"

@interface PRViewController () <MPMediaPickerControllerDelegate>

@property (strong, nonatomic)  MPMediaItem *item;
@property (strong, nonatomic) MPMediaItemCollection * mediaItemCollection;
//Interface
@property (weak, nonatomic) IBOutlet UILabel *textDescription;
@property (weak, nonatomic) IBOutlet PRButton* mediaPikerSelectButton;
@property (weak, nonatomic) IBOutlet PRButton* playSelectedSongsButton;

@end

@implementation PRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"Primera";
    self.textDescription.text = NSLocalizedString(@"textDescription", @"text");
    [self.mediaPikerSelectButton setTitle:NSLocalizedString(@"mediaPikerSelectButton", @"button select") forState:UIControlStateNormal];
    [self.playSelectedSongsButton setTitle:NSLocalizedString(@"playSelectedSongsButton", @"button go table") forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playSelectedSongsButton setEnabled:NO];
}

#pragma mark -- ACTIONS
- (IBAction)openMediaPickerController:(id)sender{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.showsCloudItems = NO;
    mediaPicker.prompt = NSLocalizedString(@"Select songs to analized...",@"select");
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
}
#pragma mark -- Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushSongsController"]) {
        // Get destination view
        PRSongsViewController *controller = (PRSongsViewController*)[segue destinationViewController];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        //NSLog(@"Fine items %lu",(unsigned long)self.mediaItemCollection.items.count);
        [controller setMediaItemCollection:self.mediaItemCollection];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- DELEGATE
#pragma mark -- MPMediaPickerController
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) collection {
    
    self.item = [[collection items] objectAtIndex:0];
    self.mediaItemCollection = collection;
    [self dismissViewControllerAnimated:YES completion:^{
        if (collection) {
            [self.playSelectedSongsButton setEnabled:YES];
        }
    }];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end