//
//  SettingsGroup.m
//  What
//
//  Created by What on 7/29/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SettingsGroup.h"

@implementation SettingsGroup

- (id)initWithSettings:(NSArray *)settings {
    if ( self = [super init] ) {
        _settingsObjects = [NSMutableArray arrayWithArray:settings];
    }
    return self;
}

@end
