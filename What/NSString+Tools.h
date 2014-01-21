//
//  NSString+FormatFileSize.h
//  What
//
//  Created by What on 6/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end;
+(NSString *)formatFileSize:(long double)fileSize;
+ (NSString *)formatFileSize:(long double)fileSize forProfile:(BOOL)forProfile;
-(NSString *)abbreviatePostCount;

@end
