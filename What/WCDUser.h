//
//  ALUser.h
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *joinDate;
@property (nonatomic, strong) NSString *lastActiveDate;
@property (nonatomic, readwrite) BOOL donor;
@property (nonatomic, readwrite) BOOL warned;
@property (nonatomic, readwrite) BOOL enabled;
@property (nonatomic, strong) NSString *memberClass;
@property (nonatomic, strong) NSArray *snatches;
@property (nonatomic, strong) NSArray *uploads;
@property (nonatomic, strong) NSString *profileText;

//stats
@property (nonatomic, assign) double ratio;
@property (nonatomic, assign) double requiredRatio;
@property (nonatomic, assign) long double uploaded;
@property (nonatomic, assign) long double downloaded;

@end
