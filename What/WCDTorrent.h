//
//  ALTorrent.h
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDFile.h"
#import "WCDAlbum.h"

@interface WCDTorrent : NSObject

@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, assign) NSInteger groupIdNum;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *encoding;
@property (nonatomic, readwrite) BOOL scene;
@property (nonatomic, readwrite) BOOL hasCue;
@property (nonatomic, readwrite) BOOL hasLog;
@property (nonatomic, assign) NSInteger logScore;
@property (nonatomic, assign) NSInteger fileCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger seeders;
@property (nonatomic, assign) NSInteger leechers;
@property (nonatomic, assign) NSInteger snatches;
@property (nonatomic, readwrite) BOOL freeTorrent;
@property (nonatomic, strong) NSArray *fileListArray;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, readwrite) BOOL remastered;
@property (nonatomic, assign) NSInteger remasterYear;
@property (nonatomic, strong) NSString *remasterTitle;
@property (nonatomic, strong) NSString *remasterRecordLabel;
@property (nonatomic, strong) NSString *remasterCatalogueNumber;

//@property (nonatomic, strong) NSMutableArray *files;

@property (nonatomic, weak) WCDAlbum *parentAlbum;

@end
