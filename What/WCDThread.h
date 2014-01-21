//
//  ALThread.h
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDThread : NSObject

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger authorId;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, readwrite) BOOL locked;
@property (nonatomic, readwrite) BOOL sticky;
@property (nonatomic, readwrite) BOOL read;
@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, strong) NSString *lastAuthorName;
@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, assign) NSInteger lastReadPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *posts;


@end
