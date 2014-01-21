//
//  ALAlbum.h
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDAlbum : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, assign) NSInteger releaseType;
@property (nonatomic, strong) NSString *releaseTypeString;
@property (nonatomic, strong) NSString *recordLabel;
@property (nonatomic, strong) NSString *catalogueNumber;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSArray *tags;
//@property (nonatomic, strong) NSArray *unorganizedTorrents;

@property (nonatomic, strong) NSMutableDictionary *torrentsDictionary;

@end
