//
//  ALPost.h
//  What
//
//  Created by What on 7/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDUser.h"
#import "BBParsingElement.h"
#import "WCDPostContent.h"

@interface WCDPost : NSObject

@property (nonatomic, strong) WCDUser *user;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSString *addedTime;
//@property (nonatomic, strong) BBParsingElement *parsedElement;
//@property (nonatomic, strong) NSString *htmlContent;
@property (nonatomic, strong) WCDPostContent *content;

@end
