//
//  MyBBCodeParser.h
//  What
//
//  Created by What on 6/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCodeParser.h"

@interface MyBBCodeParser : NSObject

-(void)parseCode:(NSString *)code completion:(void(^)(BBElement *parsedElement))completion;

@end
