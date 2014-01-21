//
//  InboxController.m
//  What
//
//  Created by What on 6/11/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "InboxTableViewController.h"
#import "API.h"
#import <MessageUI/MessageUI.h>
#import "InboxTableViewCell.h"
#import "ConversationTableViewController.h"
#import "ProfileTableViewController.h"
#import "NSDate+Tools.h"
#import "NSString+HTML.h"
#import "WCDInbox.h"
#import "WCDConversation.h"
#import "ThreadTableViewController.h"
#import "UserSingleton.h"

@interface InboxTableViewController ()

@property (nonatomic, strong) WCDInbox *inbox;

@end

@implementation InboxTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        _inbox = [[WCDInbox alloc] init];
        [self updateTitle];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTitle {
    NSString *inboxWithMessages = [UserSingleton sharedInstance].newMessages > 0 ? [NSString stringWithFormat:@"Inbox (%i)", [UserSingleton sharedInstance].newMessages] : @"Inbox";
    self.title = NSLocalizedString(inboxWithMessages, inboxWithMessages);
}

- (void)viewDidLoad
{
    //paginator needs to be initialized BEFORE super's viewDidLoad
    self.paginator = [[InboxPaginator alloc] initWithDelegate:self];

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //TODO refresh when app enters foreground
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ConversationCellIdentifier = @"ConversationCellIdentifier";
    
    InboxTableViewCell *cell = (InboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConversationCellIdentifier];
    
    if (cell == nil) {
        cell = [[InboxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConversationCellIdentifier];
        
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAvatar:)];
        [cell.senderAvatar addGestureRecognizer:tapAvatar];
    }
    
    if ([self.inbox.conversations count] > 0) {
        WCDConversation *conversation = [self.inbox.conversations objectAtIndex:indexPath.row];
        cell.conversation = conversation;
        cell.senderAvatar.tag = indexPath.row;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    WCDConversation *conversation = [self.inbox.conversations objectAtIndex:indexPath.row];
    ConversationTableViewController *conversationController = [[ConversationTableViewController alloc] initWithConversation:conversation];
    [self.navigationController pushViewController:conversationController animated:YES];
    
    if (conversation.unread) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            conversation.unread = NO;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            NSInteger updatedNewMessages = MAX([UserSingleton sharedInstance].newMessages - 1, 0);
            [[UserSingleton sharedInstance] setNewMessages:updatedNewMessages];
            [[UserSingleton sharedInstance] saveData];
            [self updateTitle];
        });
    }
}

-(void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [self.inbox.conversations addObjectsFromArray:[NSArray arrayWithArray:results]];
    [super paginator:paginator didReceiveResults:results];
    
    uint unreadCount = 0;
    for (WCDConversation *conversation in self.inbox.conversations)
    {
        if (conversation.unread)
            unreadCount++;
    }
    
    [[UserSingleton sharedInstance] setNewMessages:unreadCount];
    [[UserSingleton sharedInstance] saveData];
    [self updateTitle];
    
    [self.pullToRefreshView finishLoading];
    [self hideLoadingView];
}

#pragma mark - Custom Methods

-(void)refresh {
    [self.paginator fetchFirstPage];
}

-(void)tappedAvatar:(UITapGestureRecognizer *)gesture
{
    WCDConversation *conversation = [self.inbox.conversations objectAtIndex:gesture.view.tag];
    ProfileTableViewController *userProfile = [[ProfileTableViewController alloc] initWithUser:conversation.user];
    [self.navigationController pushViewController:userProfile animated:YES];
}

@end
