//
//  NSDate+Tools.h
//  What
//
//  Created by What on 6/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tools)

+(NSString *)relativeDateFromDateString:(NSString *)dateString;
+(NSString *)relativeDateFromNow;
+(NSString *)monthFromDateString:(NSString *)dateString;
+(NSString *)yearFromDateString:(NSString *)dateString;
+(NSString *)timeFromDateString:(NSString *)dateString;

@end
