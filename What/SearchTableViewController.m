//
//  Search.m
//  What
//
//  Created by What on 5/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchTableViewController.h"
#import "UIApplication+AppDimensions.h"
#import "API.h"
#import "SearchBarTableViewCell.h"
#import "SearchCategoryTableViewCell.h"
#import "SearchUsersTableViewController.h"
#import "SearchAlbumsTableViewController.h"
#import "SearchArtistsTableViewController.h"
#import "Sequencer.h"
#import "UserSingleton.h"
#import "UIBarButtonItem+Tools.h"
#import "SearchTableViewCell.h"
#import "AppDelegate.h"
#import <UIViewController+MMDrawerController.h>

static int cMaxNumberOfRecentSearches = 10;

@interface SearchTableViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) NSUInteger sectionOneRowsCount;
@property (nonatomic, strong) NSMutableArray *recentSearches;
@property (nonatomic, strong) NSString *currentSearch;

@end

@implementation SearchTableViewController

@synthesize searchBar = searchBar_;

- (id)initWithStyle:(UITableViewStyle)style
{
    if ( (self=[super initWithStyle:UITableViewStyleGrouped]) )
    {
        self.title = NSLocalizedString(@"Search", @"Search");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem drawerButtonWithTarget:self selector:@selector(showDrawer:)];
    
    if ([Constants deviceHasLargerScreen])
        [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView-568h.png"]]];
    else
        [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView.png"]]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor colorFromHexString:cForumTableSeparatorDarkColor];
    
    if ([Constants iOSVersion] >= 7.0) {
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }
    
    UIBarButtonItem *cameraButton = [UIBarButtonItem cameraButtonWithTarget:self selector:@selector(scan)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    self.sectionOneRowsCount = 2;
    self.recentSearches = [NSMutableArray arrayWithArray:[UserSingleton sharedInstance].recentSearches];
}

- (void)showDrawer:(id)sender {
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([UserSingleton sharedInstance].showRecentSearches)
        return 2;
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.sectionOneRowsCount;
    
    else
    {
        if (self.recentSearches.count == 0)
            return 1;
        
        return self.recentSearches.count + 1; //+1 for clear all
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchBarCellIdentifier = @"SearchBarCellIdentifier";
    static NSString *SearchCategoryCellIdentifier = @"SearchCategoryCellIdentifier";
    static NSString *ShowRecentsCellIdentifier = @"ShowRecentsCellIdentifier";
    static NSString *RecentSearchesCellIdentifier = @"RecentSearchesCellIdentifier";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == self.sectionOneRowsCount - 1)
        {
            SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ShowRecentsCellIdentifier];
            
            if (cell == nil) {
                cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShowRecentsCellIdentifier];
                if ([Constants iOSVersion] < 7.0)
                    [cell roundCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            }
            
            if ([UserSingleton sharedInstance].showRecentSearches)
                cell.textLabel.text = @"Hide recent searches";
            else
                cell.textLabel.text = @"Show recent searches";
            
            
            
            return cell;
        }
        
        else if (indexPath.row == 0)
        {
            
            SearchBarTableViewCell *cell = (SearchBarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchBarCellIdentifier];
            
            if (cell == nil) {
                cell = [[SearchBarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchBarCellIdentifier];
                self.searchBar = cell.searchBar;
                self.searchBar.delegate = self;
                if ([Constants iOSVersion] < 7.0)
                    [cell roundCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
            }
        
            return cell;
        }
        
        else
        {
            SearchCategoryTableViewCell *cell = (SearchCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchCategoryCellIdentifier];
            
            if (cell == nil) {
                cell = [[SearchCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCategoryCellIdentifier];
                if ([Constants iOSVersion] < 7.0)
                    [cell roundCorners:0];
            }
            
            if (indexPath.row == 1)
                [cell setCellType:ArtistCellType];
            
            else if (indexPath.row == 2)
                [cell setCellType:AlbumCellType];
            
            else if (indexPath.row == 3)
                [cell setCellType:UserCellType];
            
            if (self.currentSearch.length > 0)
                [cell appendText:self.currentSearch];
            
            return cell;
            
        }
    }
    
    //recent searches
    else
    {
        SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecentSearchesCellIdentifier];
        
        if (cell == nil) {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecentSearchesCellIdentifier];
        }
        
        if (self.recentSearches.count == 0)
            cell.textLabel.text = @"No recent searches";
        else if (indexPath.row == self.recentSearches.count)
            cell.textLabel.text = @"Clear All";
        else
            cell.textLabel.text = (self.recentSearches)[indexPath.row];
        
        if (indexPath.row == 0 && [tableView numberOfRowsInSection:indexPath.section] == 1) {
            [cell roundCorners:UIRectCornerAllCorners];
        } else if (indexPath.row == 0) {
            [cell roundCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
        } else if (indexPath.row == self.recentSearches.count) {
            [cell roundCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        } else {
            [cell roundCorners:0];
        }
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*2, kSectionHeaderHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [Constants appFontWithSize:10.f bolded:YES];
        titleLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
        titleLabel.text = @"Recent Searches";
        titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        titleLabel.layer.shadowOpacity = 1.f;
        titleLabel.layer.shadowRadius = 0.f;
        
        [view addSubview:titleLabel];
        return view;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return kSectionHeaderHeight;
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorFromHexString:cForumCellGradientLightColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 0)
        return;
    
    NSString *searchTerm = self.searchBar.text;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == self.sectionOneRowsCount - 1)
        {
            [UserSingleton sharedInstance].showRecentSearches = ![UserSingleton sharedInstance].showRecentSearches;
            [[UserSingleton sharedInstance] saveData];
            
            if ([UserSingleton sharedInstance].showRecentSearches)
            {
                //add recents
                [self.tableView beginUpdates];
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.sectionOneRowsCount - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            
            else
            {
                //remove recents
                [self.tableView beginUpdates];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.sectionOneRowsCount - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
        
        else if (searchTerm.length > 0)
        {
            if (![self.recentSearches containsObject:searchTerm])
            {
                [self.recentSearches insertObject:searchTerm atIndex:0];
                NSArray *oldRecentSearches = [NSArray arrayWithArray:self.recentSearches];
                
                if (oldRecentSearches.count > cMaxNumberOfRecentSearches)
                    [self.recentSearches removeLastObject];
                                
                [UserSingleton sharedInstance].recentSearches = [NSArray arrayWithArray:self.recentSearches];
                [[UserSingleton sharedInstance] saveData];
                
                if ([self numberOfSectionsInTableView:tableView] > 1)
                {
                    [self.tableView beginUpdates];
                    
                    //delete "no recent searches" row
                    if (self.recentSearches.count == 1)
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                    
                    //delete last row
                    else if (oldRecentSearches.count > cMaxNumberOfRecentSearches)
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.recentSearches.count - 1) inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
                    
                    //insert new search (and clear all button if this is the first recent search added)
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], self.recentSearches.count == 1 ? [NSIndexPath indexPathForRow:1 inSection:1] : nil, nil] withRowAnimation:UITableViewRowAnimationTop];
                    
                    //reload row that just got moved to update the rounded corners
                    if (self.recentSearches.count > 1)
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

                    [self.tableView endUpdates];
                }
            }
            
            if (self.sectionOneRowsCount != 2)
            {
                if (indexPath.row == 1)
                {
                    SearchArtistsTableViewController *searchArtists = [[SearchArtistsTableViewController alloc] initWithSearchTerm:self.searchBar.text];
                    [self.navigationController pushViewController:searchArtists animated:YES];
                }
                
                else if (indexPath.row == 2)
                {
                    SearchAlbumsTableViewController *searchTorrents = [[SearchAlbumsTableViewController alloc] initWithSearchTerm:self.searchBar.text];
                    [self.navigationController pushViewController:searchTorrents animated:YES];
                }
                
                else if (indexPath.row == 3)
                {
                    SearchUsersTableViewController *searchUsers = [[SearchUsersTableViewController alloc] initWithSearchTerm:self.searchBar.text];
                    [self.navigationController pushViewController:searchUsers animated:YES];
                }
            }
        }
    }
    
    else
    {
        if (indexPath.row == self.recentSearches.count && self.recentSearches.count > 0) {
            NSMutableArray *indexPathsToDelete = [NSMutableArray new];
            for (int i = 0; i < self.recentSearches.count; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:1]];
            }
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPathsToDelete.count inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            self.recentSearches = [[NSMutableArray alloc] init];
            [self.tableView endUpdates];
            
            [UserSingleton sharedInstance].recentSearches = [NSArray arrayWithArray:self.recentSearches];
            [[UserSingleton sharedInstance] saveData];
            
        } else if ([self.recentSearches count] > 0) {
            NSString *recentSearch = [self.recentSearches objectAtIndex:indexPath.row];
            [self.searchBar setText:recentSearch];
            [self searchBar:self.searchBar textDidChange:recentSearch];
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
        return 44.f;
        
    return 40.f;
}

#pragma mark - UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.currentSearch = [NSString stringWithFormat:@"\"%@\"", searchText];
    
    NSMutableArray *indices = [NSMutableArray new];
    
    if (self.sectionOneRowsCount != 2) {
        for (int i = 1; i < self.sectionOneRowsCount - 1; i++)
            [indices addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (searchText.length != 0) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        else {
            self.sectionOneRowsCount = 2;
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
    }
    
    else if (searchText.length > 0 && self.sectionOneRowsCount == 2) {
        self.sectionOneRowsCount = 5;
        for (int i = 1; i < self.sectionOneRowsCount - 1; i++)
            [indices addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark - Scanner

-(void)scan {
    BarcodeController *reader = [[BarcodeController alloc] init];
    reader.delegate = self;
    [self presentModalViewController:reader animated:YES];
}

-(void)handleBarcode:(NSString *)upc
{
    [self dismissModalViewControllerAnimated:YES];
    
    Sequencer *sequencer = [[Sequencer alloc] init];
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] searchMusicBrainzWithBarcode:upc];
        [API musicBrainzSearchRequest:request completionBlockWithResults:^(NSDictionary *responseDict) {
            if (!responseDict) {
                //if no results, go to next step
                completion(nil);
            }
            
            else
            {
                NSDictionary *release = [[responseDict objectForKey:@"releases"] objectAtIndex:0];
                //NSDictionary *artistCredit = [[release objectForKey:@"artist-credit"] objectAtIndex:0];
                //NSDictionary *artistInfo = [artistCredit objectForKey:@"artist"];
                
                //NSString *artist = [artistInfo objectForKey:@"name"];
                NSString *title = [release objectForKey:@"title"];
                
                [self.searchBar setText:title];
                [self searchBar:self.searchBar textDidChange:title];
            }
        }];
    }];
    
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] searchDiscogsWithBarcode:upc];
        [API discogsSearchRequest:request completionBlockWithResults:^(NSDictionary *responseDict) {
            if (!responseDict) {
                //if no results, go to next step
                completion(nil);
            }
            
            else
            {
                NSArray *results = [responseDict objectForKey:@"results"];
                NSDictionary *resultDict = [results objectAtIndex:0];
                
                NSArray *titleComponents = [[resultDict objectForKey:@"title"] componentsSeparatedByString:@" - "];
                
                //NSString *artist = [titleComponents objectAtIndex:0];
                NSString *title = [titleComponents objectAtIndex:1];
                
                [self.searchBar setText:title];
                [self searchBar:self.searchBar textDidChange:title];
            }
        }];
    }];
    
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showAlertBannerWithTitle:@"No Search Results" subtitle:@"No results were found for this barcode. Try again with another one." style:ALAlertBannerStyleFailure];
        
    }];
    
    [sequencer run];
     
}


#pragma mark - UIScrollView

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder])
        [self.searchBar resignFirstResponder];
}

#pragma mark - Custom Methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
