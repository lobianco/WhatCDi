//
//  ALForum.h
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDForum : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSMutableArray *threads;

@end
