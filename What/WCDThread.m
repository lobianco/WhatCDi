//
//  ALThread.m
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDThread.h"

@implementation WCDThread

-(instancetype)init
{
    self = [super init];
    if (self) {
        _posts = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
