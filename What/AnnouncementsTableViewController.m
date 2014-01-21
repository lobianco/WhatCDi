//
//  HomeViewController.m
//  What
//
//  Created by What on 4/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AnnouncementsTableViewController.h"
#import "AppDelegate.h"
#import "API.h"
#import "WCDAnnouncementGroup.h"
#import "WCDAnnouncement.h"
#import "AnnouncementsTableViewCell.h"
#import "MyHTMLParser.h"
#import "AnnouncementsDetailTableViewController.h"

@interface AnnouncementsTableViewController ()

@property (nonatomic, strong) WCDAnnouncementGroup *announcementGroup;
@property (nonatomic, strong) NSDictionary *JSON;

@end

@implementation AnnouncementsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _announcementGroup = [[WCDAnnouncementGroup alloc] init];
        
        self.title = NSLocalizedString(@"Announcements", @"Announcements");
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.announcementGroup.announcements.count > 0) {
        //[self refreshWithJSON:self.JSON];
        //[self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.announcementGroup.announcements count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NewsCellIdentifier = @"NewsCellIdentifier";
    AnnouncementsTableViewCell *cell = (AnnouncementsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    
    if (cell == nil) {
        cell = [[AnnouncementsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier];
    }
    
    WCDAnnouncement *announcement = (WCDAnnouncement*)[self.announcementGroup.announcements objectAtIndex:indexPath.section];
    cell.announcement = announcement;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AnnouncementsTableViewCell height];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    WCDAnnouncement *announcement = (WCDAnnouncement*)[self.announcementGroup.announcements objectAtIndex:indexPath.section];
    AnnouncementsDetailTableViewController *detail = [[AnnouncementsDetailTableViewController alloc] initWithAnnouncement:announcement];
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - Custom Methods

-(void)refresh {
    int oldSectionsCount = self.announcementGroup.announcements.count;
    NSURLRequest *request = [[API sharedInterface] getAnnouncements];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        //NSLog(@"%@", JSON);
        NSDictionary *JSONdict = (NSDictionary *)JSON;
        _JSON = JSONdict;
        [self refreshWithJSON:JSONdict];
        [self.tableView beginUpdates];
        if (oldSectionsCount > 0)
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldSectionsCount)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.announcementGroup.announcements.count)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
        
    } failureBlockWithError:^(id error) {
        
        NSLog(@"error: %@", (NSError *)error);
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
        
    }];
}

- (void)refreshWithJSON:(NSDictionary *)JSON {
    NSDictionary *response = [JSON objectForKey:@"response"];
    NSMutableArray *announcementsArray = [NSMutableArray new];
    for (NSDictionary *announcementDict in [response objectForKey:@"announcements"]) {
        WCDAnnouncement *announcement = [[WCDAnnouncement alloc] init];
        announcement.idNum = [[announcementDict objectForKey:@"newsId"] integerValue];
        announcement.title = [announcementDict objectForKey:@"title"];
        announcement.bbBody = [announcementDict objectForKey:@"bbBody"];
        announcement.htmlBody = [announcementDict objectForKey:@"body"];
        announcement.newsTime = [announcementDict objectForKey:@"newsTime"];
        announcement.imageURL = [MyHTMLParser extractFirstImageFromHTML:[announcementDict objectForKey:@"body"]];
        [announcementsArray addObject:announcement];
    }
    self.announcementGroup.announcements = [NSArray arrayWithArray:announcementsArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
