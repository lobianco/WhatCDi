//
//  ForumStyleController.h
//  What
//
//  Created by What on 9/9/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainTableViewController.h"
#import "WCDThread.h"
#import "ThreadTableViewCell.h"

@interface DiscussionController : MainTableViewController

@property (nonatomic, strong) WCDThread *thread;
@property (nonatomic) BOOL shouldDynamicallyReloadHeights;
@property (nonatomic, getter = isLoading) BOOL loading;

//- (void)setHeight:(CGFloat)height forSection:(NSInteger)section;
//- (void)preloadContent:(NSString *)content forPostNumber:(NSInteger)number;

@end
