//
//  ForumWithReplyController.h
//  What
//
//  Created by What on 9/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DiscussionController.h"
#import "ReplyView.h"


@interface DiscussionWithReplyController : DiscussionController

@property (nonatomic, strong) ReplyView *replyView;
@property (nonatomic, strong) NSMutableArray *preloadContent;
@property (nonatomic) int contentCounter;

- (void)preloadContent:(NSString *)content;

@end
