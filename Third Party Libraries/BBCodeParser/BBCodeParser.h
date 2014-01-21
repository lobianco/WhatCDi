//
//  BBCodeParser.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Optimized by What on 7/3/13
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBParsingElement.h"

@class BBParsingElement;

@interface BBCodeParser : NSObject 
    
@property (nonatomic, readonly) BBParsingElement *element;
@property (nonatomic, copy) NSString *code;

- (id)initWithTags:(NSArray *)tags;
- (void)parse;

+ (NSString *)tagRegexPattern;

@end