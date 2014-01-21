//
//  Forum_ForumView.h
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "PaginatorTableViewController.h"
#import "WCDForum.h"

@interface ForumTableViewController : PaginatorTableViewController

- (id)initWithForum:(WCDForum *)forum;

@end
