//
//  ALReleaseType.m
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDReleaseGroup.h"

@implementation WCDReleaseGroup

-(instancetype)init
{
    self = [super init];
    if (self) {
        _objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"release group dealloc");
    _name = nil;
    _objects = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> name=\"%@\"", [self class], self, _name];
}

@end
