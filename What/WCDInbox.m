//
//  ALMessageGroup.m
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDInbox.h"

@implementation WCDInbox

-(instancetype)init
{
    self = [super init];
    if (self) {
        _conversations = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
