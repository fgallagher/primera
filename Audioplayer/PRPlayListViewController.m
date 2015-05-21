//
//  PRPlayListViewController.m
//  Audioplayer
//
//  Created by KSJS Mac on 4/9/15.
//  Copyright (c) 2015 Paolo Rossignoli. All rights reserved.
//

#import "PRPlayListViewController.h"
#import "PRSongsViewController.h"
#import "PRAppDelegate.h"

@interface PRPlayListViewController()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *playList;
@property (strong, nonatomic) NSMutableDictionary *playListSongs;

@end
@implementation PRPlayListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title =@"Primera";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPlayList];
    CGFloat x = self.tableView.frame.origin.x;
    CGFloat y = self.tableView.frame.origin.y;
    if (!loaded) {
        loaded = YES;
        [PRAppDelegate storyBoradAutoLay:self.view];
    }
    self.tableView.frame = CGRectMake(x, y, self.tableView.frame.size.width, self.tableView.frame.size.height);

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.playList.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.playList[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.opaque = NO;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    [self didSelectPlayListAction:row];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void) initPlayList{
    if (!self.playList) {
        self.playList = [NSMutableArray new];
    }else{
        [self.playList removeAllObjects];
    }
    if (!self.playListSongs) {
        self.playListSongs = [NSMutableDictionary new];
    }else{
        [self.playListSongs removeAllObjects];
    }
       MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    for (MPMediaPlaylist *playlist in playlists) {
        int playListAttributes = [[playlist valueForProperty: MPMediaPlaylistPropertyPlaylistAttributes] intValue];
        
        // Does the play list have no attributes or the 'On The Go' attribute
        if( playListAttributes == MPMediaPlaylistAttributeNone || playListAttributes & MPMediaPlaylistAttributeOnTheGo ) {
            NSString *playListName = [playlist valueForProperty: MPMediaPlaylistPropertyName];

            [self.playList addObject:playListName];
            NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
            NSArray *songs = [playlist items];
            for (MPMediaItem *song in songs) {
                NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                NSLog (@"\t\t%@", songTitle);
            }
            MPMediaItemCollection *mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:songs];
            self.playListSongs[playListName] = mediaItemCollection;
        }
    }
    [self.tableView reloadData];
}

-(void)didSelectPlayListAction:(NSInteger)row{
    NSString *playListName = self.playList[row];
    MPMediaItemCollection *mediaItemCollection = self.playListSongs[playListName];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PRSongsViewController *controller = [board instantiateViewControllerWithIdentifier:@"SongViewController"];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSLog(@"Fine items %lu",(unsigned long)mediaItemCollection.items.count);
    [controller setMediaItemCollection:mediaItemCollection];
    [self.navigationController pushViewController:controller animated:NO];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Playlist";
}
@end
