//
//  NewsDetailViewController.h
//  What
//
//  Created by What on 9/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DiscussionController.h"
#import "WCDAnnouncement.h"

@interface AnnouncementsDetailTableViewController : DiscussionController

- (id)initWithAnnouncement:(WCDAnnouncement *)announcement;

@end
