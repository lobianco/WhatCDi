//
//  AppDelegate.h
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerVisualState.h>
#import "MainNavigationController.h"
#import <ALAlertBanner/ALAlertBanner.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMDrawerController *sidePanelController;
@property (strong, nonatomic) MainNavigationController *profileNav;
@property (strong, nonatomic) MainNavigationController *forumNav;
@property (strong, nonatomic) MainNavigationController *searchNav;
@property (strong, nonatomic) MainNavigationController *homeNav;
//@property (strong, nonatomic) MainNavigationController *albumNav;
@property (strong, nonatomic) MainNavigationController *inboxNav;
//@property (strong, nonatomic) MainNavigationController *artistNav;
@property (strong, nonatomic) MainNavigationController *torrentsNav;
@property (strong, nonatomic) MainNavigationController *settingsNav;

@property (nonatomic, weak) MainNavigationController *visibleNavigationController;
@property (strong, nonatomic, readonly) NSArray *navigationControllers;
@property (strong, nonatomic, readonly) NSMutableArray *navigationControllerNames;

- (void)logout;
- (void)loadIndexAndUserData;
- (void)updateInboxCount:(NSInteger)count;
- (void)showAlertBannerWithTitle:(NSString*)title subtitle:(NSString*)subtitle style:(ALAlertBannerStyle)style;
- (void)showFailureAlertBannerWithError:(NSError *)error;

@end
