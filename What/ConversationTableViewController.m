//
//  InboxConversationController.m
//  What
//
//  Created by What on 6/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "API.h"
#import "ConversationMessageCell.h"
#import "NSString+HTML.h"
#import "UserSingleton.h"
#import "ConversationHeaderView.h"
#import "NSDate+Tools.h"
#import "ProfileTableViewController.h"
#import "ThreadSectionHeaderView.h"
#import "ReplyView.h"
#import "MyBBCodeParser.h"
#import "UIBarButtonItem+Tools.h"

#define kKeyboardHeightPortrait 216

@interface ConversationTableViewController ()

@property (nonatomic, strong) ReplyView *replyView;

@end

@implementation ConversationTableViewController 

- (id)initWithConversation:(WCDConversation *)conversation
{
    self = [super init];
    if (self) {
        
        self.thread.topicId = conversation.idNum;
        self.thread.authorId = conversation.user.idNum;
        
        self.title = NSLocalizedString(conversation.subject, conversation.subject);
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.loading = YES;
    
    [super viewDidLoad];
    
    //don't allow replies to System messages
    BOOL canReply = (self.thread.authorId != 0);
    if (canReply) {
        //reply view
        UIBarButtonItem *scrollButton = [UIBarButtonItem replyButtonWithTarget:self selector:@selector(reply:)];
        scrollButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = scrollButton;
        
        [self.view addSubview:self.replyView];
    }
}

#pragma mark - Custom Methods

- (void)refresh {
    //[super refresh];
    [self loadConversation];
}

-(void)loadConversation
{
    //int oldCount = self.thread.posts.count;
    
    NSURLRequest *request = [[API sharedInterface] getInboxConversation:[NSString stringWithFormat:@"%i", self.thread.topicId]];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        NSArray *messages = [response objectForKey:@"messages"];
        
        NSMutableArray *messagesArray = [NSMutableArray new];
        NSInteger i = 1;
        for (NSDictionary *messageDict in messages)
        {
            WCDPost *post = [[WCDPost alloc] init];
            post.idNum = i;
            post.addedTime = [messageDict objectForKey:@"sentDate"];
            
            WCDPostContent *postContent = [[WCDPostContent alloc] init];
            postContent.htmlBody = [messageDict objectForKey:wHTML_BODY];
            postContent.cellHeight = 0;
            post.content = postContent;
            
            WCDUser *user = [[WCDUser alloc] init];
            user.idNum = [[messageDict objectForKey:@"senderId"] integerValue];
            user.name = [messageDict objectForKey:@"senderName"];
            user.avatarURL = [NSURL URLWithString:[messageDict objectForKey:@"avatar"]];
            
            post.user = user;
            
            [messagesArray addObject:post];
            
            i++;
            
        }
        
        self.thread.posts = [NSMutableArray arrayWithArray:messagesArray];
        
        //preload content
        self.preloadContent = nil;
        for (WCDPost *post in self.thread.posts) {
            [self preloadContent:post.content.htmlBody];
        }
        
        /*
        [self.tableView beginUpdates];
        if (oldCount > 0)
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldCount)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.thread.posts.count)] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
                
        //get last row:
        int lastSection = [self.thread.posts count] - 1;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:lastSection] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
        
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
         */
        
    } failureBlockWithError:^(id error) {
        
        NSLog(@"error: %@", (NSError *)error);
        
        [self.pullToRefreshView finishLoading];
        [self hideLoadingView];
        
    }];
}

@end
