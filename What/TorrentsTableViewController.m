//
//  TorrentsController.m
//  What
//
//  Created by What on 7/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "TorrentsTableViewController.h"
#import "SearchAlbumTableViewCell.h"
#import "AlbumTableViewController.h"

@interface TorrentsTableViewController ()

@end

@implementation TorrentsTableViewController

-(id)init
{
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Latest Torrents", @"Latest Torrents");
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    //paginator needs to be initialized BEFORE super's viewDidLoad
    self.paginator = [[TorrentsPaginator alloc] initWithDelegate:self];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Table View Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchAlbumCellIdentifier = @"SearchAlbumCellIdentifier";
    
    SearchAlbumTableViewCell *cell = (SearchAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchAlbumCellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchAlbumCellIdentifier];
    }
    
    //well shit. don't know why i need this...
    if ([self.paginator.results count] > 0) {
        WCDAlbum *album = [self.paginator.results objectAtIndex:indexPath.row];
        cell.album = album;
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.paginator.results.count > 0)
    {
        WCDAlbum *album = [self.paginator.results objectAtIndex:indexPath.row];
        AlbumTableViewController *albumController = [[AlbumTableViewController alloc] initWithAlbum:album];
        [self.navigationController pushViewController:albumController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchAlbumTableViewCell heightForAlbumCell];
}

-(void)refresh {
    [self.paginator fetchFirstPage];
}

-(void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [self.pullToRefreshView finishLoading];
    [self hideLoadingView];
    [super paginator:paginator didReceiveResults:results];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
