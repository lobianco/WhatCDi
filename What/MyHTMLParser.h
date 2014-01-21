//
//  MyHTMLParser.h
//  What
//
//  Created by What on 6/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHTMLParser : NSObject

+(BOOL)htmlContainsRichText:(NSString *)html;
+ (NSURL *)extractFirstImageFromHTML:(NSString *)html;

@end
