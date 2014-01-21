//
//  SearchTorrentsController.m
//  What
//
//  Created by What on 6/13/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchAlbumsTableViewController.h"
#import "API.h"
#import "AlbumTableViewController.h"
#import "SearchAlbumTableViewCell.h"
#import "WCDAlbum.h"

@interface SearchAlbumsTableViewController ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchAlbumsTableViewController

@synthesize searchTerm = searchTerm_;

- (id)initWithSearchTerm:(NSString *)searchTerm
{
    if ( (self=[super init]) )
    {
        searchTerm_ = searchTerm;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.pullToRefreshView removeFromSuperview];
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    
    self.paginator = [[SearchAlbumsPaginator alloc] initWithDelegate:self searchTerm:self.searchTerm];
    [self.paginator fetchFirstPage];
    
}

#pragma mark - Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchCellIdentifier = @"SearchCellIdentifier";
    
    SearchAlbumTableViewCell *cell = (SearchAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier];
    }
    
    if ([self.paginator.results count] > 0) {
        WCDAlbum *album = [self.paginator.results objectAtIndex:indexPath.row];
        cell.album = album;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchAlbumTableViewCell heightForAlbumCell];
}

# pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCDAlbum *album = [self.paginator.results objectAtIndex:indexPath.row];
    //AlbumController *albumController = [[AlbumController alloc] initWithAlbumId:album.idNum artistName:album.artist albumTitle:album.name];
    AlbumTableViewController *albumController = [[AlbumTableViewController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:albumController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
