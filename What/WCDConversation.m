//
//  ALConversation.m
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDConversation.h"

@implementation WCDConversation

-(NSString *)description
{
    return [NSString stringWithFormat:@"Conversation from %@ on %@ (%@) - %@", self.user.name, self.dateString, self.unread ? @"unread" : @"read", self.subject];
}

@end
