//
//  ALForum.m
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDForum.h"

@implementation WCDForum


-(instancetype)init
{
    self = [super init];
    if (self) {
        _threads = [[NSMutableArray alloc] init];
    }
    return self;
}
 

@end
