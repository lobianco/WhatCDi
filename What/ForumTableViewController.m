//
//  Forum_ForumView.m
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ForumTableViewController.h"
#import "ThreadTableViewController.h"
#import "API.h"
#import "ForumTableViewCell.h"
#import "NSString+HTML.h"
#import "WCDForum.h"
#import "WCDThread.h"
#import "CategorySectionHeaderView.h"
#import "UIBarButtonItem+Tools.h"
#import "UserSingleton.h"

@interface ForumTableViewController ()

@property (nonatomic, strong) WCDForum *forum;

@end

@implementation ForumTableViewController

- (id)initWithForum:(WCDForum *)forum
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        
        _forum = forum;
        self.title = NSLocalizedString(forum.name, forum.name);
        
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"dealloced forum");
    
    _forum = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    //paginator needs to be initialized BEFORE super's viewDidLoad
    self.paginator = [[ForumListPaginator alloc] initWithDelegate:self pageId:self.forum.idNum];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ForumCellIdentifier = @"ForumCellIdentifier";
    ForumTableViewCell *cell = (ForumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumCellIdentifier];
    
    if (cell == nil) {
        cell = [[ForumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ForumCellIdentifier];
    }
    
    if ([self.forum.threads count] > 0) {
        WCDThread *thread = [self.forum.threads objectAtIndex:indexPath.row];
        cell.thread = thread;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ALThread *thread = (ALThread *)(self.forum.threads)[indexPath.row];
    WCDThread *thread = [self.paginator.results objectAtIndex:indexPath.row];
    return [ForumTableViewCell heightForTitle:thread.title];
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.forum.name == nil) {
        return nil;
    }
    
    CategorySectionHeaderView *headerView = [[CategorySectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    headerView.title.text = self.forum.name;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.f;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    WCDThread *thread = [self.forum.threads objectAtIndex:indexPath.row];
    NSInteger pageToOpen = ([UserSingleton sharedInstance].forumOpenTo == ForumOpenToFirstPage ? 1 : ceil(thread.postCount / 25.0)); //25 posts per page
    ThreadTableViewController *threadController = [[ThreadTableViewController alloc] initWithThread:thread openToPage:pageToOpen];
    
    [self.navigationController pushViewController:threadController animated:YES];
    
    //TODO if user navigates to last page while within thread, instead of just opening to last page
    if (!thread.read && [UserSingleton sharedInstance].forumOpenTo == ForumOpenToLastPage) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            thread.read = YES;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        });
    }
}

-(void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [self.forum.threads addObjectsFromArray:results];
    [super paginator:paginator didReceiveResults:results];
    
    [self.pullToRefreshView finishLoading];
    [self hideLoadingView];
}

-(void)refresh
{
    [self.paginator fetchFirstPage];
}

@end
