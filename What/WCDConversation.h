//
//  ALConversation.h
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDThread.h"
#import "WCDUser.h"

@interface WCDConversation : NSObject

@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, readwrite) BOOL unread;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) WCDUser *user;
@property (nonatomic, strong) NSArray *messages;

@end
