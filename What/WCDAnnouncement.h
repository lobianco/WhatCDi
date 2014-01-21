//
//  ALAnnouncement.h
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBParsingElement.h"

@interface WCDAnnouncement : NSObject

@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *htmlBody;
@property (nonatomic, strong) NSString *bbBody;
@property (nonatomic, strong) NSString *newsTime;
@property (nonatomic, strong) NSURL *imageURL;

@end
