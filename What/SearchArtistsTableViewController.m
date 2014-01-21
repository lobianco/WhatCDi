//
//  SearchArtistsController.m
//  What
//
//  Created by What on 6/13/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchArtistsTableViewController.h"
#import "API.h"
#import "ArtistTableViewController.h"
#import "WCDArtist.h"
#import "SearchArtistTableViewCell.h"
#import "NSString+HTML.h"

@interface SearchArtistsTableViewController ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchArtistsTableViewController

- (id)initWithSearchTerm:(NSString *)searchTerm
{
    if ( (self=[super init]) )
    {
        _searchTerm = searchTerm;
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
    
    self.paginator = [[SearchArtistsPaginator alloc] initWithDelegate:self searchTerm:self.searchTerm];
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
    static NSString *SearchArtistCellIdentifier = @"SearchArtistCellIdentifier";
    
    SearchArtistTableViewCell *cell = (SearchArtistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchArtistCellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchArtistCellIdentifier];
    }
    
    if ([self.paginator.results count] > 0) {
        WCDArtist *artist = [self.paginator.results objectAtIndex:indexPath.row];
        cell.artist = artist;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchArtistTableViewCell heightForRow];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCDArtist *artist = [self.paginator.results objectAtIndex:indexPath.row];
    ArtistTableViewController *artistController = [[ArtistTableViewController alloc] initWithArtist:artist];
    [self.navigationController pushViewController:artistController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
