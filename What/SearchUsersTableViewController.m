//
//  SearchUsersController.m
//  What
//
//  Created by What on 6/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchUsersTableViewController.h"
#import "UIApplication+AppDimensions.h"
#import "API.h"
#import "SearchUsersTableViewCell.h"
#import "ProfileTableViewController.h"
#import "NSString+HTML.h"

@interface SearchUsersTableViewController ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchUsersTableViewController

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
        
    self.paginator = [[SearchUsersPaginator alloc] initWithDelegate:self searchTerm:self.searchTerm];
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
    static NSString *SearchUsersCellIdentifier = @"SearchUsersCellIdentifier";
    
    SearchUsersTableViewCell *cell = (SearchUsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchUsersCellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchUsersCellIdentifier];
    }
    
    if ([self.paginator.results count] > 0) {
        WCDUser *user = [self.paginator.results objectAtIndex:indexPath.row];
        cell.user = user;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchUsersTableViewCell heightForRow];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCDUser *user = [self.paginator.results objectAtIndex:indexPath.row];
    ProfileTableViewController *userProfile = [[ProfileTableViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:userProfile animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
