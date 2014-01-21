//
//  SettingsGroup.h
//  What
//
//  Created by What on 7/29/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsGroup : NSObject

- (id)initWithSettings:(NSArray *)settings;

@property (nonatomic, strong) NSMutableArray *settingsObjects;
@property (nonatomic, strong) NSString *title;

@end
