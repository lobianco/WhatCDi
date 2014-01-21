//
//  ThreadView.m
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ThreadTableViewController.h"
#import "API.h"
#import "UserSingleton.h"
#import "PageControlsView.h"
#import "WCDPost.h"
#import "UIBarButtonItem+Tools.h"
#import "ReplyView.h"
#import "ThreadSectionHeaderView.h"
#import "NSDate+Tools.h"
#import "NSString+HTML.h"
#import "AppDelegate.h"

static CGFloat const kPageControlsHeight = 40.f;

@interface ThreadTableViewController () <ALPageControlsDelegate>

@property (nonatomic, strong) PageControlsView *headerControls;
@property (nonatomic, strong) PageControlsView *footerControls;

@end

@implementation ThreadTableViewController

- (id)initWithThread:(WCDThread *)thread openToPage:(NSInteger)page {
    self = [self init];
    if (self) {
        
        self.thread = thread;
        self.thread.currentPage = page;
        
        self.title = NSLocalizedString(thread.title, thread.title);
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"thread table dealloc");
    
    _headerControls = nil;
    _footerControls = nil;
}


- (void)viewDidLoad {
    self.loading = YES;
    
    [super viewDidLoad];
    
    BOOL canReply = !self.thread.locked;
    if (canReply)
    {
        //reply view
        UIBarButtonItem *scrollButton = [UIBarButtonItem replyButtonWithTarget:self selector:@selector(reply:)];
        scrollButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = scrollButton;
        
        [self.view addSubview:self.replyView];
    }
    
    //page controls
    self.headerControls = [[PageControlsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPageControlsHeight)];
    self.headerControls.delegate = self;
    self.headerControls.tag = 1;
    
    self.footerControls = [[PageControlsView alloc] initWithFrame:self.headerControls.frame];
    self.footerControls.delegate = self;
    self.footerControls.tag = 2;

}

-(void)gotoFirstPage
{    
    if (self.thread.currentPage != 1) {
        [self gotoPage:1];
    }
    
    else
        NSLog(@"already on first page");
}

-(void)gotoLastPage
{    
    if (self.thread.currentPage != self.thread.numberOfPages) {
        [self gotoPage:self.thread.numberOfPages];
    }
    
    else
        NSLog(@"already on last page");
}

-(void)gotoNextPage
{    
    if (self.thread.currentPage < self.thread.numberOfPages) {
        [self gotoPage:(self.thread.currentPage+1)];
    }
    
    else
        NSLog(@"no more pages");
}

-(void)gotoPreviousPage
{    
    if (self.thread.currentPage > 1) {
        [self gotoPage:(self.thread.currentPage-1)];
    }
    
    else
        NSLog(@"no earlier pages");
}

-(void)gotoPage:(NSInteger)page
{    
    if (self.thread.currentPage != page) {        
        self.thread.currentPage = page;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingView];
            [self.pullToRefreshView startLoading];
        });
    }
}

-(void)refresh {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.tableView.numberOfSections > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadThreadPage:self.thread.currentPage];
    });
}

#pragma mark - Custom Methods

//TODO push new controller for each new page?
-(void)loadThreadPage:(NSInteger)page {
    NSURLRequest *request = [[API sharedInterface] getForumThreadView:[NSString stringWithFormat:@"%i", self.thread.topicId] postId:@"" page:[NSString stringWithFormat:@"%i", page]];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *JSONdict = (NSDictionary *)JSON;
        NSDictionary *response = [JSONdict objectForKey:wRESPONSE];
        
        
        self.thread.title = [[response objectForKey:wTHREAD_TITLE] stringByDecodingHTMLEntities];
        self.thread.numberOfPages = [[response objectForKey:@"pages"] integerValue];
        self.headerControls.pickerItems = self.thread.numberOfPages;
        self.footerControls.pickerItems = self.thread.numberOfPages;
        
        if (self.tableView.tableHeaderView != self.headerControls)
            self.tableView.tableHeaderView = self.headerControls;
        
        if (self.tableView.tableFooterView != self.footerControls)
            self.tableView.tableFooterView = self.footerControls;
        
        NSInteger lastPage = self.thread.currentPage;
        self.thread.currentPage = [[response objectForKey:@"currentPage"] integerValue];
        [self.headerControls setPage:self.thread.currentPage lastIndex:lastPage];
        [self.footerControls setPage:self.thread.currentPage lastIndex:lastPage];
        
        NSMutableArray *threadPosts = [NSMutableArray new];
        
        NSArray *posts = [response objectForKey:wPOSTS];
        int i = 0;
        for (NSDictionary *post in posts)
        {
            WCDPost *myPost = [[WCDPost alloc] init];
            myPost.idNum = [[post objectForKey:wPOST_ID] integerValue];
            myPost.addedTime = [post objectForKey:wADDED_TIME];
            
            WCDPostContent *postContent = [[WCDPostContent alloc] init];
            postContent.htmlBody = [post objectForKey:wHTML_BODY];
            postContent.cellHeight = 0;
            myPost.content = postContent;
            
            WCDUser *user = [[WCDUser alloc] init];
            user.name = [[post objectForKey:wAUTHOR] objectForKey:wAUTHOR_NAME];
            user.idNum = [[[post objectForKey:wAUTHOR] objectForKey:@"authorId"] integerValue];
            user.avatarURL = [NSURL URLWithString:[[post objectForKey:wAUTHOR] objectForKey:@"avatar"]];
            
            myPost.user = user;
            
            [threadPosts addObject:myPost];
            
            i++;
        }
        
        self.thread.posts = [NSMutableArray arrayWithArray:threadPosts];
        
        //preload content
        self.preloadContent = nil;
        for (WCDPost *post in self.thread.posts) {
            [self preloadContent:post.content.htmlBody];
        }
        
        //update title in case we came here from a link in a thread
        self.title = NSLocalizedString(self.thread.title, self.thread.title);
                
    } failureBlockWithError:^(id error) {
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
        
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //[appDelegate showFailureAlertBannerWithError:error];
    }];
}

@end
