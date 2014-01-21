//
//  NewsDetailViewController.m
//  What
//
//  Created by What on 9/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AnnouncementsDetailTableViewController.h"
#import "WCDPost.h"

@interface AnnouncementsDetailTableViewController ()

@property (nonatomic, weak) WCDAnnouncement *announcement;

@end

@implementation AnnouncementsDetailTableViewController

- (id)initWithAnnouncement:(WCDAnnouncement *)announcement {
    self = [super init];
    if (self) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoading:) name:@"WebViewLoaded" object:nil];
        
        _announcement = announcement;
        
        self.title = NSLocalizedString(announcement.title, announcement.title);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"announcement detail dealloc");
    
    _announcement = nil;
}

- (void)finishedLoading:(NSNotification *)note {
    ThreadTableViewCell *cell = (ThreadTableViewCell *)note.object;
    if ([cell.content.htmlBody isEqualToString:self.announcement.htmlBody]) {
        [self hideLoadingView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoading:) name:@"WebViewLoaded" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.loading = YES;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set this for profile and announcement controller so cell height can get updated properly. we don't do it for threadController because the cells are preloaded.
    self.shouldDynamicallyReloadHeights = YES;
    
    //remove pull to refresh for this view
    [self.pullToRefreshView removeFromSuperview];
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    
    WCDPost *post = [[WCDPost alloc] init];
    WCDPostContent *postContent = [[WCDPostContent alloc] init];
    postContent.htmlBody = self.announcement.htmlBody;
    postContent.cellHeight = 0;
    post.content = postContent;
    [self.thread.posts addObject:post];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView beginUpdates];
        self.loading = NO;
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
