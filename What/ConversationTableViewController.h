//
//  InboxConversationController.h
//  What
//
//  Created by What on 6/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscussionWithReplyController.h"
#import "WCDConversation.h"

@interface ConversationTableViewController : DiscussionWithReplyController

- (id)initWithConversation:(WCDConversation *)conversation;

@end
