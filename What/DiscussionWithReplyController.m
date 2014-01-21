//
//  ForumWithReplyController.m
//  What
//
//  Created by What on 9/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DiscussionWithReplyController.h"
#import "ThreadSectionHeaderView.h"
#import "UserSingleton.h"
#import "API.h"
#import "NSDate+Tools.h"
#import "ThreadTableViewController.h"
#import "ConversationTableViewController.h"
#import "AppDelegate.h"
#import "WCDPost.h"
#import "NSString+HTML.h"

@interface DiscussionWithReplyController () <ALReplyViewDelegate, UIWebViewDelegate>

//for preloading content
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DiscussionWithReplyController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"discussion with reply dealloc");
    
    _webView.delegate = nil;
    _webView.context = nil;
    _replyView.delegate = nil;
    _replyView = nil;
    [_webView removeFromSuperview];
    [_preloadContent removeAllObjects];
    _preloadContent = nil;
    _contentCounter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //[contentToPreload removeAllObjects];
    //contentToPreload = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.replyView = [[ReplyView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 4.f, self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height)];
    self.replyView.delegate = self;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(400, 0, CELL_WIDTH, 1.f)];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.alpha = 0.f;
    self.webView.scrollView.scrollsToTop = NO;
    self.webView.scrollView.scrollEnabled = NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WCDPost *post = [self.thread.posts objectAtIndex:section];
    
    ThreadSectionHeaderView *headerView = [[ThreadSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    headerView.post = post;
    headerView.avatar.tag = section;
    
    if (section % 2)
        [headerView setColor:[UIColor colorFromHexString:cThreadCellOddColor]];
    else
        [headerView setColor:[UIColor colorFromHexString:cThreadCellEvenColor]]; 
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAvatar:)];
    [headerView.avatar addGestureRecognizer:tapGesture];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ThreadSectionHeaderView heightForHeader];
}

# pragma mark - ALReplyViewDelegate

-(void)reply:(id)sender {
    [self showReplyView:YES];
}

-(void)postReply:(NSString *)replyText {
    replyText = [[replyText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"\n"];
    NSMutableString *newBody = [[NSMutableString alloc] initWithString:replyText];
    if ([UserSingleton sharedInstance].useSignature) {
        [newBody appendFormat:@"\n\n%@", [UserSingleton sharedInstance].signature];
    }
    
    //[self addReplyCell:[newBody stringWithNewLinesAsBRs]];
    //[self showReplyView:NO];

    NSURLRequest *request;
    if ([self isKindOfClass:[ThreadTableViewController class]]) {
        request = [[API sharedInterface] postForumThreadReply:newBody threadId:self.thread.topicId];
    } else if ([self isKindOfClass:[ConversationTableViewController class]]) {
        request = [[API sharedInterface] postInboxMessageReply:newBody withConversationId:self.thread.topicId toUser:self.thread.authorId];
    } else {
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [API postRequest:request completionBlockWithResponse:^(id responseObject) {
        
        if (responseObject) {
            //need \n for new lines for POST request but need <br /> for new lines for UIWebView
            [self addReplyCell:[newBody stringWithNewLinesAsBRs]];
            [self showReplyView:NO];
        }
        
        else {
            [self.replyView postFailed];
            [appDelegate showAlertBannerWithTitle:@"Failed To Post Reply" subtitle:@"Try sending it again. I'll cross my digits this time." style:ALAlertBannerStyleFailure];
        }
        
    } failureBlockWithError:^(NSError *error) {
        [self.replyView postFailed];
        //[appDelegate showFailureAlertBannerWithError:error];
    }];
}

-(void)showReplyView:(BOOL)show {
    [self.navigationController setNavigationBarHidden:show animated:YES];
    double delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.replyView show:show];
    });
}

-(void)addReplyCell:(NSString *)body
{
    WCDPost *post = [[WCDPost alloc] init];
    WCDPostContent *postContent = [[WCDPostContent alloc] init];
    postContent.htmlBody = body;
    post.content = postContent;
    post.addedTime = [NSDate relativeDateFromNow];
    post.idNum = self.thread.posts.count + 1;
    
    WCDUser *user = [[WCDUser alloc] init];
    user.name = [UserSingleton sharedInstance].username;
    user.idNum = [[UserSingleton sharedInstance] userId];
    user.avatarURL = [NSURL URLWithString:[UserSingleton sharedInstance].avatarString];
    
    post.user = user;
    
    [self.thread.posts addObject:post];
    
    self.contentCounter = self.thread.posts.count - 1;
    [self startPreloadingWithCompletion:^(BOOL finished) {
        self.webView.context = nil;
        self.webView.delegate = nil;
        [self.webView removeFromSuperview];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView beginUpdates];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.thread.posts.count - 1, 1)] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.thread.posts.count - 1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        });
    }];
}

# pragma mark - Preload UIWebViews

- (void)enableReplyButton {
    if (self.navigationItem.rightBarButtonItem)
        self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)preloadContent:(NSString *)content {
    if (!self.preloadContent) {
        self.preloadContent = [[NSMutableArray alloc] initWithCapacity:25];
        self.contentCounter = 0;
    }
        
    [self.preloadContent addObject:content];
    
    //first load
    if (self.preloadContent.count == 1) {
       [self startPreloadingWithCompletion:^(BOOL finished) {
           NSLog(@"removed view");
           
           //NOTE must nil out the context or this controller won't dealloc
           self.webView.context = nil;
           self.webView.delegate = nil;
           [self.webView removeFromSuperview];
           
           [self.preloadContent removeAllObjects];
           self.preloadContent = nil;
                      
           double delayInSeconds = 0.5;
           dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
           dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               int currentNumberOfSections = self.tableView.numberOfSections;
               [self.tableView beginUpdates];
               if (self.isLoading) {
                   self.loading = NO;
               } else {
                   if (currentNumberOfSections > 0) {
                       [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, currentNumberOfSections)] withRowAnimation:UITableViewRowAnimationFade];
                   }
               }
               [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.thread.posts.count)] withRowAnimation:UITableViewRowAnimationFade];
               [self.tableView endUpdates];
               
               [self enableReplyButton];
               if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading)
                   [self.pullToRefreshView finishLoading];
               if ([self loaderIsShowing]) {
                   [self hideLoadingView];
               }
           });
       }];
    }
}

- (void)startPreloadingWithCompletion:(void(^)(BOOL finished))completion {
    self.webView.delegate = self;
    self.webView.context = completion;
    [self.view addSubview:self.webView];
    WCDPost *post = (WCDPost *)[self.thread.posts objectAtIndex:self.contentCounter];
    NSString *formattedHTML = [ThreadTableViewCell formatHTML:post.content.htmlBody forPreload:YES];
    [self.webView loadHTMLString:formattedHTML baseURL:[UserSingleton sharedInstance].useSSL ? [NSURL URLWithString:cHostNameSSL] : [NSURL URLWithString:cHostName]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSInteger height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    
    WCDPost *post = (WCDPost *)[self.thread.posts objectAtIndex:self.contentCounter];
    if (height != post.content.cellHeight) {
        post.content.cellHeight = height;
    }
    
    self.contentCounter++;
    if (self.contentCounter < self.preloadContent.count) {
        NSString *formattedHTML = [ThreadTableViewCell formatHTML:[self.preloadContent objectAtIndex:self.contentCounter] forPreload:YES];
        [self.webView loadHTMLString:formattedHTML baseURL:[UserSingleton sharedInstance].useSSL ? [NSURL URLWithString:cHostNameSSL] : [NSURL URLWithString:cHostName]];
    } else {
        BOOL (^completion)() = self.webView.context;
        completion(YES);
    }
}

@end
