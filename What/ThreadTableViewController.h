//
//  ThreadView.h
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussionWithReplyController.h"

@interface ThreadTableViewController : DiscussionWithReplyController

- (id)initWithThread:(WCDThread *)thread openToPage:(NSInteger)page;

@end