//
//  SectionInfo.m
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDSectionInfo.h"

@implementation WCDSectionInfo

- (void)dealloc {
    _releaseGroup = nil;
    NSLog(@"section ifo dealloc");
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> release=\"%@\"", [self class], self, _releaseGroup];
}

@end
