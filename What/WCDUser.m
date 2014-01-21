//
//  ALUser.m
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDUser.h"

@implementation WCDUser

/*
-(BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self isEqualToObject:object];
}

- (BOOL)isEqualToObject:(ALUser *)object {
    if (self == object)
        return YES;
    if ([self name] != [object name] && ![(id)[self name] isEqual:[object name]])
        return NO;
    if ([self idNum] != [object idNum])
        return NO;
    return YES;
}
 */

-(NSString *)description
{
    return [NSString stringWithFormat:@"USER: name: %@ idNum: %i", self.name, self.idNum];
}

@end
