//
//  MenuController.m
//  What
//
//  Created by What on 5/23/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MenuController.h"
#import "AppDelegate.h"
#import "UIApplication+AppDimensions.h"
#import "SettingsTable.h"
#import "UserSingleton.h"
#import "UIColor+Tools.h"
#import "MenuTableFooter.h"
#import "SettingsTable.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "SettingsTableHeader.h"
#import <objc/runtime.h>
#import "MenuTable.h"
#import "DonationTable.h"
#import "WCDThread.h"
#import "ThreadTableViewController.h"

#define MAX_DRAWER_WIDTH 340.f
#define MIN_DRAWER_WIDTH 280.f
#define HEIGHT_OFFSET [Constants iOSVersion] >= 7.0 ? 20.f : 0.f

@interface UITableView (Convenience)
@property (nonatomic) BOOL isVisible;
@end

@implementation UITableView (Convenience)
@dynamic isVisible;
-(void)setIsVisible:(BOOL)isVisible {
    objc_setAssociatedObject(self, @selector(isVisible), [NSNumber numberWithBool:isVisible], OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isVisible {
    return [objc_getAssociatedObject(self, @selector(isVisible)) boolValue];
}
@end

@interface MenuController ()

@property (nonatomic, strong) MenuTable *menuTable;
@property (nonatomic, strong) SettingsTable *settingsTable;
@property (nonatomic, strong) DonationTable *donationTable;

@property (nonatomic, readwrite) BOOL draggingFooter;
@property (nonatomic, readwrite) BOOL draggingHeader;

@end

@implementation MenuController


-(void)loadView
{    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.f, [UIApplication currentSize].width, [UIApplication currentSize].height)];
    [newView setBackgroundColor:[UIColor colorFromHexString:cMenuTableHeaderBackgroundColor]];
    self.view = newView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.settingsTable = [[SettingsTable alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    //this stuff must stay out here, instead of putting it inside settingstable.m
    self.settingsTable.parentController = self;
    self.settingsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, [SettingsTableHeader height])];
    [self.view addSubview:self.settingsTable];
    self.settingsTable.settingsTableHeader = [[SettingsTableHeader alloc] initWithFrame:CGRectMake(0, [SettingsTableHeader height] - self.settingsTable.frame.size.height, CELL_WIDTH, self.settingsTable.frame.size.height)];
    //self.settingsTable.settingsTableHeader.parentController = self;
    [self.settingsTable addSubview:self.settingsTable.settingsTableHeader];
    
    //this stuff must stay out here, instead of putting it inside menutable.m
    self.menuTable = [[MenuTable alloc] initWithFrame:CGRectMake(0, [self heightOffsetForiOS7], self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.menuTable.parentController = self;
    self.menuTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, [MenuTableHeader height])];
    [self.view addSubview:self.menuTable];
    self.menuTable.menuTableHeader = [[MenuTableHeader alloc] initWithFrame:CGRectMake(0, [MenuTableHeader height] - self.menuTable.frame.size.height, CELL_WIDTH, self.menuTable.frame.size.height)];
    //[self.menuTable.menuTableHeader.settingsButton addTarget:self action:@selector(pushSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.menuTable.menuTableHeader.heartButton addTarget:self action:@selector(pushDonation) forControlEvents:UIControlEventTouchUpInside];
    [self.menuTable addSubview:self.menuTable.menuTableHeader];
    self.menuTable.menuTableFooter = [[MenuTableFooter alloc] initWithFrame:CGRectMake(0, self.menuTable.frame.size.height - [MenuTableFooter height], CELL_WIDTH, self.menuTable.frame.size.height)];
    [self.menuTable addSubview:self.menuTable.menuTableFooter];
    [self.menuTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.donationTable = [[DonationTable alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.donationTable.parentController = self;
    [self.view addSubview:self.donationTable];
    
    self.menuTable.isVisible = YES;
    self.settingsTable.isVisible = NO;
    self.donationTable.isVisible = NO;
    self.draggingFooter = NO;
    self.draggingHeader = NO;
}

-(void)updateMenuHeaderWithUser:(WCDUser *)user {
    self.menuTable.menuTableHeader.user = user;
}

- (void)updateMenuTable {
    [self.menuTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoFeedbackForum {
    [self popSettings];
    [self openForumThread:183788];
}

- (void)gotoBugsForum {
    [self popSettings];
    [self openForumThread:176699];
}

- (void)openForumThread:(NSInteger)threadId {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            WCDThread *thread = [[WCDThread alloc] init];
            thread.topicId = threadId;
            ThreadTableViewController *threadController = [[ThreadTableViewController alloc] initWithThread:thread openToPage:1];
            [appDelegate.visibleNavigationController pushViewController:threadController animated:YES];
        }];
    });
}

- (void)pushDonation {
    self.menuTable.isVisible = NO;
    self.settingsTable.isVisible = NO;
    self.donationTable.isVisible = NO;
    
    if (self.mm_visibleDrawerFrame.size.width != MAX_DRAWER_WIDTH)
    {
        __weak MMDrawerController *weakDrawer = self.mm_drawerController;
        [self.mm_drawerController setMaximumLeftDrawerWidth:MAX_DRAWER_WIDTH animated:YES completion:^(BOOL finished) {
            [weakDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        }];
    }
    
    self.menuTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.menuTable.frame.size.width, self.menuTable.frame.size.height);
    self.donationTable.frame = CGRectMake(0, -self.view.frame.size.height, self.donationTable.frame.size.width, self.donationTable.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuTable.frame = CGRectMake(0, self.view.frame.size.height, self.menuTable.frame.size.width, self.menuTable.frame.size.height);
        self.donationTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.donationTable.frame.size.width, self.donationTable.frame.size.height);
    } completion:^(BOOL finished) {
        self.donationTable.isVisible = YES;
        self.menuTable.scrollEnabled = YES;
    }];
}

- (void)popDonation {
    self.menuTable.isVisible = NO;
    self.settingsTable.isVisible = NO;
    self.donationTable.isVisible = NO;
    
    if (self.mm_visibleDrawerFrame.size.width != MIN_DRAWER_WIDTH)
    {
        __weak MMDrawerController *weakDrawer = self.mm_drawerController;
        [self.mm_drawerController setMaximumLeftDrawerWidth:MIN_DRAWER_WIDTH animated:YES completion:^(BOOL finished) {
            [weakDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView|MMCloseDrawerGestureModePanningCenterView|MMCloseDrawerGestureModePanningNavigationBar|MMCloseDrawerGestureModeTapCenterView|MMCloseDrawerGestureModeTapNavigationBar|MMCloseDrawerGestureModePanningDrawerView];
        }];
    }
    
    self.menuTable.frame = CGRectMake(0, self.view.frame.size.height, self.menuTable.frame.size.width, self.menuTable.frame.size.height);
    self.donationTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.donationTable.frame.size.width, self.donationTable.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.menuTable.frame.size.width, self.menuTable.frame.size.height);
        self.donationTable.frame = CGRectMake(0, -self.view.frame.size.height, self.donationTable.frame.size.width, self.donationTable.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuTable.isVisible = YES;
        self.donationTable.scrollEnabled = YES;
    }];
}

-(void)pushSettings
{
    self.menuTable.isVisible = NO;
    self.settingsTable.isVisible = NO;
    self.donationTable.isVisible = NO;
    
    [self.settingsTable addNotifications];
    
    if (self.mm_visibleDrawerFrame.size.width != MAX_DRAWER_WIDTH)
    {
        __weak MMDrawerController *weakDrawer = self.mm_drawerController;
        [self.mm_drawerController setMaximumLeftDrawerWidth:MAX_DRAWER_WIDTH animated:YES completion:^(BOOL finished) {
            [weakDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        }];
    }
    
    self.menuTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.menuTable.frame.size.width, self.menuTable.frame.size.height);
    self.settingsTable.frame = CGRectMake(0, self.view.frame.size.height, self.settingsTable.frame.size.width, self.settingsTable.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuTable.frame = CGRectMake(0, (self.view.frame.size.height * -1), self.menuTable.frame.size.width, self.menuTable.frame.size.height);
        self.settingsTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.settingsTable.frame.size.width, self.settingsTable.frame.size.height);
    } completion:^(BOOL finished) {
        self.settingsTable.isVisible = YES;
        self.menuTable.scrollEnabled = YES;
    }];
}

-(void)popSettings
{
    self.menuTable.isVisible = NO;
    self.settingsTable.isVisible = NO;
    self.donationTable.isVisible = NO;
    
    [self.settingsTable removeNotifications];
    
    if (self.mm_visibleDrawerFrame.size.width != MIN_DRAWER_WIDTH)
    {
        __weak MMDrawerController *weakDrawer = self.mm_drawerController;
        [self.mm_drawerController setMaximumLeftDrawerWidth:MIN_DRAWER_WIDTH animated:YES completion:^(BOOL finished) {
            [weakDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView|MMCloseDrawerGestureModePanningCenterView|MMCloseDrawerGestureModePanningNavigationBar|MMCloseDrawerGestureModeTapCenterView|MMCloseDrawerGestureModeTapNavigationBar|MMCloseDrawerGestureModePanningDrawerView];
        }];
    }
    
    [self.settingsTable endEditing:YES];
    
    self.menuTable.frame = CGRectMake(0, (self.view.frame.size.height * -1), self.menuTable.frame.size.width, self.menuTable.frame.size.height);
    self.settingsTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.settingsTable.frame.size.width, self.settingsTable.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuTable.frame = CGRectMake(0, [self heightOffsetForiOS7], self.menuTable.frame.size.width, self.menuTable.frame.size.height);
        self.settingsTable.frame = CGRectMake(0, self.view.frame.size.height, self.settingsTable.frame.size.width, self.settingsTable.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuTable.isVisible = YES;
        self.settingsTable.scrollEnabled = YES;
    }];
}

- (CGFloat)heightOffsetForiOS7
{
    return [Constants iOSVersion] >= 7.0 ? 20.f : 0.f;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint startPoint = [scrollView.panGestureRecognizer locationInView:self.view];
    //not sure why, but touches register a few pixels above where the actually occur. offset that here.
    CGPoint correctedPointForFooter = CGPointMake(startPoint.x, startPoint.y + 6.f);
    self.draggingFooter = CGRectContainsPoint(self.menuTable.menuTableFooter.frame, correctedPointForFooter);
    
    if (!self.draggingFooter) {
        CGPoint correctedPointForHeader = CGPointMake(startPoint.x, startPoint.y - 10.f);
        self.draggingHeader = CGRectContainsPoint(self.menuTable.menuTableHeader.frame, correctedPointForHeader);
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.menuTable.isVisible && !self.settingsTable.isVisible && !self.donationTable.isVisible)
        return;
    
    //if on menu screen and not dragging header or footer, we don't care about it
    if (self.menuTable.isVisible && !self.draggingHeader && !self.draggingFooter)
        return;
        
    CGFloat bottom = scrollView.contentSize.height - scrollView.frame.size.height > 0 ? scrollView.contentSize.height - scrollView.frame.size.height : 0.f;
    CGFloat drawerWidth = 0.f;
    
    if (self.menuTable.isVisible && self.draggingFooter)
    {
        drawerWidth = MIN_DRAWER_WIDTH;
        drawerWidth = MAX(drawerWidth, (drawerWidth + ((scrollView.contentOffset.y*(40.f/60.f))/2)));
        drawerWidth = MIN(drawerWidth, MAX_DRAWER_WIDTH);
    }
    
    if (self.menuTable.isVisible && self.draggingHeader)
    {
        drawerWidth = MIN_DRAWER_WIDTH;
        drawerWidth = MAX(drawerWidth, (drawerWidth + (((scrollView.contentOffset.y * -1)*(40.f/60.f))/2)));
        drawerWidth = MIN(drawerWidth, MAX_DRAWER_WIDTH);
    }
    
    else if (self.settingsTable.isVisible)
    {
        drawerWidth = MAX_DRAWER_WIDTH;
        drawerWidth = MIN(drawerWidth, (drawerWidth - ((scrollView.contentOffset.y * -1)*(40.f/60.f))/2));
        drawerWidth = MAX(drawerWidth, MIN_DRAWER_WIDTH);
    }
    
    else if (self.donationTable.isVisible)
    {
        drawerWidth = MAX_DRAWER_WIDTH;
        drawerWidth = MIN(drawerWidth, (drawerWidth - ((scrollView.contentOffset.y - bottom)*(40.f/60.f))/2));
        drawerWidth = MAX(drawerWidth, MIN_DRAWER_WIDTH);
    }
    
    [self.mm_drawerController setMaximumLeftDrawerWidth:drawerWidth];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //if on menu screen and not dragging header or footer, we don't care about it
    if (self.menuTable.isVisible && !self.draggingHeader && !self.draggingFooter)
        return;
    
    CGFloat bottom = scrollView.contentSize.height - scrollView.frame.size.height > 0 ? scrollView.contentSize.height - scrollView.frame.size.height : 0.f;
    
    if ([scrollView isKindOfClass:[MenuTable class]] && (scrollView.contentOffset.y - bottom) >= TABLE_OFFSET_FOR_SCROLL)
    {
        scrollView.scrollEnabled = NO;
        [self pushSettings];
    }
    
    else if ([scrollView isKindOfClass:[SettingsTable class]] && scrollView.contentOffset.y <= (TABLE_OFFSET_FOR_SCROLL * -1))
    {
        scrollView.scrollEnabled = NO;
        [self popSettings];
    }
    
    else if ([scrollView isKindOfClass:[MenuTable class]] && scrollView.contentOffset.y <= (TABLE_OFFSET_FOR_SCROLL * -1)) {
        scrollView.scrollEnabled = NO;
        [self pushDonation];
    }
    
    else if ([scrollView isKindOfClass:[DonationTable class]] && (scrollView.contentOffset.y - bottom) >= TABLE_OFFSET_FOR_SCROLL) {
        scrollView.scrollEnabled = NO;
        [self popDonation];
    }
}

@end
