//
//  MenuController.h
//  What
//
//  Created by What on 5/23/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDUser.h"

#define TABLE_OFFSET_FOR_SCROLL 60.f

@interface MenuController : UITableViewController

- (void)updateMenuTable;
- (void)updateMenuHeaderWithUser:(WCDUser *)user;
- (void)gotoFeedbackForum;
- (void)gotoBugsForum;

@end
