//
//  AppDelegate.m
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AppDelegate.h"
//#import <Dropbox/Dropbox.h>
#import "ProfileTableViewController.h"
#import "AnnouncementsTableViewController.h"
#import "CategoryTableViewController.h"
#import "LoginTableViewController.h"
#import "SearchTableViewController.h"
#import "MenuController.h"
#import "AlbumTableViewController.h"
#import "UserSingleton.h"
#import "InboxTableViewController.h"
#import "ArtistTableViewController.h"
#import "Sequencer.h"
#import "API.h"
#import "TorrentsTableViewController.h"
#import "SettingsTable.h"
#import "LaunchTableViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic, strong) MenuController *menu;
@property (strong, nonatomic) NSArray *navigationControllers;
@property (strong, nonatomic) NSMutableArray *navigationControllerNames;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //create directory for jailbroken app
    //mkdir("/var/mobile/Library/What", 0755);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
        
    UINavigationController *launchController = [[UINavigationController alloc] initWithRootViewController:[[LaunchTableViewController alloc] init]];;
    [launchController setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = launchController;
    
    [self.window makeKeyAndVisible];
    
    if ([Constants iOSVersion] >= 7.0) {
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    
    //put this here instead of applicationDidBecomeActive:
    [[UserSingleton sharedInstance] loadData];
    [self login];
    
    return YES;
}

-(MMDrawerController*)drawerControllerForLocalUser:(WCDUser *)user
{
    self.menu = [[MenuController alloc] init];
    
    AnnouncementsTableViewController *home = [[AnnouncementsTableViewController alloc] init];
    self.homeNav = [[MainNavigationController alloc] initWithRootViewController:home];
    
    ProfileTableViewController *profile = [[ProfileTableViewController alloc] initWithUser:user];
    self.profileNav = [[MainNavigationController alloc] initWithRootViewController:profile];
    
    CategoryTableViewController *forum = [[CategoryTableViewController alloc] init];
    self.forumNav = [[MainNavigationController alloc] initWithRootViewController:forum];
    
    SearchTableViewController *search = [[SearchTableViewController alloc] init];
    self.searchNav = [[MainNavigationController alloc] initWithRootViewController:search];
    
    InboxTableViewController *inbox = [[InboxTableViewController alloc] init];
    self.inboxNav = [[MainNavigationController alloc] initWithRootViewController:inbox];
    
    TorrentsTableViewController *torrents = [[TorrentsTableViewController alloc] init];
    self.torrentsNav = [[MainNavigationController alloc] initWithRootViewController:torrents];
    
    UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:self.menu];
    [menuNav setNavigationBarHidden:YES];
    
    self.sidePanelController = [[MMDrawerController alloc] initWithCenterViewController:self.homeNav leftDrawerViewController:menuNav];
    [self.sidePanelController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.sidePanelController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView|MMCloseDrawerGestureModePanningCenterView|MMCloseDrawerGestureModePanningNavigationBar|MMCloseDrawerGestureModeTapCenterView|MMCloseDrawerGestureModeTapNavigationBar|MMCloseDrawerGestureModePanningDrawerView];
    [self.sidePanelController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:10.0f]];
    [self.sidePanelController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    [self.sidePanelController setShouldStretchDrawer:NO];
    
    self.navigationControllers = [NSArray arrayWithObjects:self.homeNav, self.torrentsNav, self.forumNav, self.inboxNav, self.profileNav, self.searchNav, nil]; //self.albumNav, self.artistNav
    self.navigationControllerNames = [NSMutableArray arrayWithObjects:@"Home", @"Torrents", @"Forums", @"Inbox", @"My Profile", @"Search", nil]; //@"Album", @"Artist"
    
    self.visibleNavigationController = self.homeNav;
    
    return self.sidePanelController;
}

#pragma mark - Login/Logout

- (void)login {
    NSDictionary *cookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:COOKIE_KEY];
    NSDictionary *cookieProperties = [UserSingleton sharedInstance].useSSL ? [cookieDictionary valueForKey:cHostNameSSL] : [cookieDictionary valueForKey:cHostName];
    
    if (!cookieProperties)
    {
        UIViewController *login = [[LoginTableViewController alloc] init];
        double delayInSeconds = 1.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.window.rootViewController presentViewController:login animated:NO completion:nil];
        });
    }
    
    else
    {
        NSLog(@"already logged in, loading info");
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithDictionary:cookieProperties]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        [self loadIndexAndUserData];
    }
}

-(void)logout {
    /*
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [[(UINavigationController*)self.window.rootViewController view].layer addAnimation:transition forKey:nil];
    [(UINavigationController*)self.window.rootViewController popToRootViewControllerAnimated:NO];
     */
    
    
    [UIView transitionWithView:[(UINavigationController*)self.window.rootViewController view] duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void) {
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [(UINavigationController*)self.window.rootViewController popToRootViewControllerAnimated:NO];
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
     
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:COOKIE_KEY];
    
    NSArray *cookies = ([[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        NSLog(@"removed cookie: %@", cookie);
    }
    
    [[UserSingleton sharedInstance] clearData];
    [[UserSingleton sharedInstance] setLoggedIn:NO];
    [[UserSingleton sharedInstance] saveData];

    [self login];
}

-(void)loadIndexAndUserData
{
    UserSingleton *userSingleton = [UserSingleton sharedInstance];
    
    Sequencer *sequencer = [[Sequencer alloc] init];
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] getIndex];
        [API getRequest:request completionBlockWithJSON:^(id JSON){
            
            NSDictionary *response = [JSON objectForKey:wRESPONSE];
            
            [userSingleton setAuthkey:[response objectForKey:@"authkey"]];
            [userSingleton setUserId:[[response objectForKey:@"id"] intValue]];
            
            //pass new messages through sequencer so we can set it after drawer controller is created
            NSNumber *newMessages = [NSNumber numberWithInteger:[[[response objectForKey:@"notifications"] objectForKey:@"messages"] integerValue]];
            completion(newMessages);
            
        } failureBlockWithError:^(id error) {
            NSLog(@"couldn't load index");
            
            if ([[(UINavigationController *)self.window.rootViewController topViewController] isKindOfClass:[LaunchTableViewController class]] && ![(UINavigationController*)self.window.rootViewController modalViewController]) {
                [self showLoginFailureAlert];
            }
            
        }];
        
    }];
    
    [sequencer enqueueStep:^(NSNumber *newMessages, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] getUserInfo:[UserSingleton sharedInstance].userId];
        [API getRequest:request completionBlockWithJSON:^(id JSON){
            
            NSDictionary *response = [JSON objectForKey:wRESPONSE];
            NSDictionary *stats = [response objectForKey:@"stats"];
            NSDictionary *personal = [response objectForKey:@"personal"];
            
            [userSingleton setUsername:[response objectForKey:@"username"]];
            [userSingleton setUploaded:[[stats objectForKey:@"uploaded"] doubleValue]];
            [userSingleton setDownloaded:[[stats objectForKey:@"downloaded"] doubleValue]];
            [userSingleton setRatio:[[stats objectForKey:@"ratio"] floatValue]];
            [userSingleton setMemberClass:[personal objectForKey:@"class"]];
            [userSingleton setJoinDate:[stats objectForKey:@"joinedDate"]];
            [userSingleton setLastActiveDate:[stats objectForKey:@"lastAccess"]];
            [userSingleton setAvatarString:[response objectForKey:@"avatar"]];
            
            completion(newMessages);
            
        } failureBlockWithError:^(id error) {
            NSLog(@"couldn't load user info");
            
            if ([[(UINavigationController *)self.window.rootViewController topViewController] isKindOfClass:[LaunchTableViewController class]] && ![(UINavigationController*)self.window.rootViewController modalViewController]) {
                [self showLoginFailureAlert];
            }
            
        }];
    }];
    
    [sequencer enqueueStep:^(NSNumber *newMessages, SequencerCompletion completion) {
        [userSingleton setLoggedIn:YES];
        [userSingleton saveData];
        
        WCDUser *me = [[WCDUser alloc] init];
        me.name = userSingleton.username;
        me.idNum = userSingleton.userId;
        me.avatarURL = [NSURL URLWithString:userSingleton.avatarString];
        
        if ([[(UINavigationController *)self.window.rootViewController topViewController] isKindOfClass:[LaunchTableViewController class]]) {
            [(UINavigationController *)self.window.rootViewController pushViewController:[self drawerControllerForLocalUser:me] animated:NO];
        }
        
        //give a delay for IOS5 otherwise it doesn't work
        double delayInSeconds = [Constants iOSVersion] < IOS6 ? 1.0 : 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.menu updateMenuHeaderWithUser:me];
        });
        
        //set inbox count
        [userSingleton setNewMessages:[newMessages integerValue]];
        
        //login controller will pop itself on this notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoggedInNotification object:nil];
    }];
    
    [sequencer run];
}

- (void)updateInboxCount:(NSInteger)count {
    //set inbox count
    NSInteger profileIndex = [self.navigationControllerNames indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [(NSString *)obj hasPrefix:@"Inbox"];
    }];
    NSString *inboxWithMessages = [UserSingleton sharedInstance].newMessages > 0 ? [NSString stringWithFormat:@"Inbox (%i)", [UserSingleton sharedInstance].newMessages] : @"Inbox";
    [self.navigationControllerNames replaceObjectAtIndex:profileIndex withObject:inboxWithMessages];
    [self.menu updateMenuTable];
}

- (void)showLoginFailureAlert {
    UIAlertView *signOutOrRefreshAlert = [[UIAlertView alloc] initWithTitle:@"Automatic Login Attempt Failed" message:@"I couldn't log you in automatically. Wait a few moments and try again." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:@"Sign Out", nil];
    [signOutOrRefreshAlert show];
}

# pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        //try again
        [self loadIndexAndUserData];
    }
    
    else {
        //sign out
        [self logout];
    }
}

# pragma mark - Alert Banners

- (void)showAlertBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(ALAlertBannerStyle)style {
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:style position:ALAlertBannerPositionBottom title:title subtitle:subtitle];
    [banner show];
}

-(void)showFailureAlertBannerWithError:(NSError *)error
{    
    ALAlertBannerStyle bannerStyle = ALAlertBannerStyleFailure;
    NSString *title;
    NSString *subtitle;
    
    //request failure
    if (!error)
    {
        title = @"Request Failure";
        subtitle = @"Please try again.";
    }
    
    else
    {
        switch (error.code) {
            //no internet connection
            case kCFURLErrorNotConnectedToInternet:
                title = @"No Internet Connection";
                subtitle = @"I can't download all those bits of data on battery power alone!";
                break;
                
            //request timed out
            case kCFURLErrorTimedOut:
                title = @"Your Request Timed Out";
                subtitle = @"Wait a few moments and give it another shot.";
                break;
                
            //HTTP 502 - bad gateway
            case kCFURLErrorBadServerResponse:
                title = @"Bad Server Response";
                subtitle = @"Wait a few moments and try again.";
                break;
                
            //a server with the specified hostname could not be found
            case kCFURLErrorCannotFindHost:
                title = @"Specified Hostname Could Not Be Found";
                subtitle = @"Wait a few moments and give it another shot.";
                break;
                
            //internet connection lost
            case kCFURLErrorNetworkConnectionLost:
                title = @"Internet Connection Was Lost";
                subtitle = @"What are we, cavemen? Find a stronger internet source!";
                break;
                
            //-1016
            case kCFURLErrorCannotDecodeContentData:
                title = @"Can't Read Website Data";
                subtitle = @"The website could be down... or I might have no idea what I'm doing. In any case, try again.";
                break;
                
            //default error message
            default:
                title = @"Something Has Gone Terribly Wrong!";
                subtitle = [NSString stringWithFormat:@"I'm just not exactly sure what it is. Error code: %i", error.code];
                break;
        }
    }
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:bannerStyle position:ALAlertBannerPositionBottom title:title subtitle:subtitle];
    [banner show];
}

#pragma mark - Application Methods

/*
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DropboxLinkageChanged" object:nil];
        
        return YES;
    }
    
    return NO;
}
 */

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //[[UserSingleton sharedInstance] saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UserSingleton sharedInstance] saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"entered foreground");
    [[UserSingleton sharedInstance] loadData];
    if ([UserSingleton sharedInstance].loggedIn) {
        [self loadIndexAndUserData];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"active");
    //[[UserSingleton sharedInstance] loadData];
    
    /*
    
    if ([UserSingleton sharedInstance].loggedIn)
    {
        NSLog(@"logged in");
        [self loadIndexAndUserData:^{
            //[[UserSingleton sharedInstance] loadData];
        }];
    }
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //TODO
    //remove all files from tmp that have -tmpDwnld
    
    [[UserSingleton sharedInstance] saveData];
}

@end
