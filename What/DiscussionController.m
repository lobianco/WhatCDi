//
//  ForumStyleController.m
//  What
//
//  Created by What on 9/9/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DiscussionController.h"
#import "HTMLParser.h"
#import "ThreadTableViewController.h"
#import "UserSingleton.h"
#import "MyBBCodeParser.h"
#import "ProfileTableViewController.h"
#import "WCDPost.h"
#import "SearchUsersTableViewController.h"
#import "AlbumTableViewController.h"
#import "OpenInChromeController.h"

@interface DiscussionController () <ThreadCellDelegate, UIActionSheetDelegate> //UIWebViewDelegate

@property (nonatomic, strong) NSMutableDictionary *cellHeights;
@property (nonatomic, strong) OpenInChromeController *openInChrome;

@end

@implementation DiscussionController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        
        _thread = [[WCDThread alloc] init];
        _shouldDynamicallyReloadHeights = NO;
        
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"discussion dealloc");
    _cellHeights = nil;
    _thread = nil;
    
}

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    self.cellHeights = [NSMutableDictionary new];
    self.openInChrome = [[OpenInChromeController alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //self.thread = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.isLoading ? 0 : [self.thread.posts count]; //+2 for header and footer
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ThreadCellIdentifier = @"ThreadCellIdentifier";
    ThreadTableViewCell *cell = (ThreadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThreadCellIdentifier];
    
    if (cell == nil) {
        cell = [[ThreadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ThreadCellIdentifier];
    }
    
    WCDPost *post = [self.thread.posts objectAtIndex:indexPath.section];
    cell.delegate = self;
    //cell.tag = indexPath.section;
    
    //don't use odd/even color constants here because we need it to match the color of the header, which uses those constants and has an alpha applied
    if (indexPath.section % 2) //if there is a remainder
        [cell setColorHex:cThreadCellOddColor]; //odd
    
    else
        [cell setColorHex:cThreadCellEvenColor]; //even
    
    //todo call this somewhere else so table doesn't refresh on scroll
    //[cell setContent:post.htmlContent];
    [cell updateContent:post.content shouldDynamicallyReloadHeight:self.shouldDynamicallyReloadHeights];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCDPost *post = [self.thread.posts objectAtIndex:indexPath.section];
    if (post.content.cellHeight) {
        return post.content.cellHeight;
    }
    return 0.f;
}

-(void)tappedAvatar:(UITapGestureRecognizer *)gesture
{
    WCDPost *post = [self.thread.posts objectAtIndex:gesture.view.tag];
    ProfileTableViewController *userController = [[ProfileTableViewController alloc] initWithUser:post.user];
    [self.navigationController pushViewController:userController animated:YES];
}

# pragma mark - Thread Cell Delegate

-(void)openLink:(NSURL *)url
{
    NSLog(@"url: %@", url);
    NSString *protocolRemoved = [url.absoluteString stringByReplacingOccurrencesOfString:@"https://what.cd/" withString:@""];
    
    //clicked on username
    //user.php?action=search&search=P1um
    NSString *urlAction = [[protocolRemoved componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([urlAction isEqualToString:@"user.php"]) {
        NSString *userSearch = [[protocolRemoved componentsSeparatedByString:@"&"] lastObject];
        NSString *user = [[userSearch componentsSeparatedByString:@"="] lastObject];
        
        SearchUsersTableViewController *searchUserController = [[SearchUsersTableViewController alloc] initWithSearchTerm:user];
        [self.navigationController pushViewController:searchUserController animated:YES];
    }
    
    //clicked on torrent
    //torrents.php?id=72425420&torrentid=30652732
    else if ([urlAction isEqualToString:@"torrents.php"]) {
        NSString *torrentSearch = [[protocolRemoved componentsSeparatedByString:@"?id="] lastObject];
        NSString *torrentId = [[torrentSearch componentsSeparatedByString:@"&"] objectAtIndex:0];
        NSLog(@"torrent: %@", torrentId);
        
        WCDAlbum *album = [[WCDAlbum alloc] init];
        album.idNum = torrentId.integerValue;
        
        AlbumTableViewController *searchAlbumsController = [[AlbumTableViewController alloc] initWithAlbum:album];
        [self.navigationController pushViewController:searchAlbumsController animated:YES];
    }
    
    //click on forum thread
    //forums.php?action=viewthread&threadid=174809
    else if ([urlAction isEqualToString:@"forums.php"]) {
        NSString *threadId = [[protocolRemoved componentsSeparatedByString:@"&threadid="] lastObject];
        
        WCDThread *thread = [[WCDThread alloc] init];
        thread.topicId = [threadId integerValue];
        
        ThreadTableViewController *threadController = [[ThreadTableViewController alloc] initWithThread:thread openToPage:1];
        [self.navigationController pushViewController:threadController animated:YES];
    }
    
    else {
        [self openLinkExternally:url];
    }
}

- (void)openLinkExternally:(NSURL *)url {
    BOOL canOpenInChrome = [self.openInChrome isChromeInstalled];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"This link couldn't be opened natively. Do you want to open it in an external browser?\n\n%@", url.absoluteString] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", canOpenInChrome ? @"Open in Chrome" : nil, nil];
    actionSheet.context = url;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    NSURL *url = (NSURL *)actionSheet.context;
    if (buttonIndex == 0) { //safari
        [[UIApplication sharedApplication] openURL:url];
    } else if (buttonIndex == 1) { //chrome
        [self.openInChrome openInChrome:url withCallbackURL:nil createNewTab:YES];
    }
    //nil out context
    actionSheet.context = nil;
}

@end
