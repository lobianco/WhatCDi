//
//  Forum.m
//  What
//
//  Created by What on 4/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "ForumTableViewController.h"
#import "API.h"
#import "CategoryTableViewCell.h"
#import "WCDCategoryGroup.h"
#import "WCDCategory.h"
#import "WCDForum.h"
#import "CategorySectionHeaderView.h"
#import "SettingsTable.h"
#import "MainNavigationController.h"
#import "ALAlertBanner.h"

@interface CategoryTableViewController ()

@property (nonatomic, strong) WCDCategoryGroup *categoryGroup;

@end

@implementation CategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _categoryGroup = [[WCDCategoryGroup alloc] init];
        
        self.title = NSLocalizedString(@"Forums", @"Forums");
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.categoryGroup.categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    WCDCategory *category = [self.categoryGroup.categories objectAtIndex:section];
    return [category.forums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CategoryCellIdentifier = @"CategoryCellIdentifier";
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
    
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CategoryCellIdentifier];
    }
    
    WCDCategory *category = [self.categoryGroup.categories objectAtIndex:indexPath.section];
    WCDForum *forum = [category.forums objectAtIndex:indexPath.row];
    cell.forum = forum;
        
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCDCategory *category = [self.categoryGroup.categories objectAtIndex:indexPath.section];
    WCDForum *forum = [category.forums objectAtIndex:indexPath.row];
    return [CategoryTableViewCell heightForLabelText:forum.name];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [(WCDCategory *)[self.categoryGroup.categories objectAtIndex:section] name];
    if (sectionTitle == nil) {
        return nil;
    }
    
    CategorySectionHeaderView *headerView = [[CategorySectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
    headerView.title.text = sectionTitle;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    WCDCategory *category = [self.categoryGroup.categories objectAtIndex:indexPath.section];
    WCDForum *forum = [category.forums objectAtIndex:indexPath.row];

    ForumTableViewController *forumView = [[ForumTableViewController alloc] initWithForum:forum];
    [self.navigationController pushViewController:forumView animated:YES];
}


#pragma mark - Custom Methods

-(void)refresh
{    
    int oldCategories = self.categoryGroup.categories.count;
    
    NSURLRequest *request = [[API sharedInterface] getForumCategoryView];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *JSONdict = (NSDictionary *)JSON;
        NSDictionary *response = [JSONdict objectForKey:@"response"];
        NSDictionary *categories = [response objectForKey:@"categories"];
        
        NSMutableArray *categoriesArray = [NSMutableArray new];
        for (NSDictionary *categoryDict in categories)
        {
            
            //category info here
            WCDCategory *category = [[WCDCategory alloc] init];
            category.name = [categoryDict objectForKey:@"categoryName"];
            category.idNum = [[categoryDict objectForKey:@"categoryId"] integerValue];
            
            NSMutableArray *forumsArray = [NSMutableArray new];
            NSDictionary *forums = [categoryDict objectForKey:@"forums"];
            for (NSDictionary *forumDict in forums)
            {
                //"forumId": 19,
                //"forumName": "Announcements",
                //"forumDescription": "If you don't like the news, go out and make some of your own.",
                //"numTopics": 338,
                //"numPosts": 84368,
                //"lastPostId": 4148491,
                //"lastAuthorId": 331548,
                //"lastPostAuthorName": "Isocline",
                //"lastTopicId": 150195,
                //"lastTime": "2012-08-08 15:03:18",
                //"specificRules": [],
                //"lastTopic": "Whataroo 2012!",
                //"read": false,
                //"locked": false,
                //"sticky": false

                WCDForum *forum = [[WCDForum alloc] init];
                forum.name = [forumDict objectForKey:@"forumName"];
                forum.idNum = [[forumDict objectForKey:@"forumId"] integerValue];
                
                [forumsArray addObject:forum];
                
            }
            
            category.forums = [NSArray arrayWithArray:forumsArray];
            
            [categoriesArray addObject:category];
        }
        
        self.categoryGroup.categories = [NSArray arrayWithArray:categoriesArray];
        
        [self.tableView beginUpdates];
        if (oldCategories > 0)
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldCategories)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.categoryGroup.categories.count)] withRowAnimation:UITableViewRowAnimationFade];
        //self.tableView.tableFooterView = self.footerShadowView;
        [self.tableView endUpdates];
        
        [self hideLoadingView];
        [self.pullToRefreshView finishLoading];
        
    } failureBlockWithError:^(id error) {
        
        NSLog(@"error: %@", (NSError *)error);
        
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
