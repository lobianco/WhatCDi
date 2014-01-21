//
//  NSString+FormatFileSize.m
//  What
//
//  Created by What on 6/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NSString+Tools.h"

typedef enum {
    B = 0,
    KB,
    MB,
    GB,
    TB,
    PB,
    EB    
} ByteType;

NSString * const byteType[] = {
    [B] = @"B",
    [KB] = @"KB",
    [MB] = @"MB",
    [GB] = @"GB",
    [TB] = @"TB",
    [PB] = @"PB",
    [EB] = @"EB"
};

typedef enum {
    k = 1,
    m = 2
} PostCount;

NSString * const postCount[] = {
    [0] = @"",
    [k] = @"k",
    [m] = @"m"
};

@implementation NSString (Tools)

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end
{
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

+(NSString *)formatFileSize:(long double)fileSize {
    return [NSString formatFileSize:fileSize count:0 forProfile:NO];
}

+ (NSString *)formatFileSize:(long double)fileSize forProfile:(BOOL)forProfile {
    return [NSString formatFileSize:fileSize count:0 forProfile:forProfile];
}

+(NSString *)formatFileSize:(long double)size count:(int)count forProfile:(BOOL)forProfile
{
    if (size < 1024.0) {
        if (forProfile) {
            return [NSString stringWithFormat:@"%.2Lf %@", size, byteType[count]];
        }
        
        return size < 10 ? [NSString stringWithFormat:@"%.1Lf%@", size, byteType[count]] : [NSString stringWithFormat:@"%.0Lf%@", size, byteType[count]];
    }
    
    count++;
    return [self formatFileSize:(size / 1024.0) count:count forProfile:forProfile];
}

-(NSString *)abbreviatePostCount {
    int posts = [self intValue];
    return [self abbreviatePostCount:posts count:0];
}

-(NSString *)abbreviatePostCount:(int)posts count:(int)count
{
    if (posts <= 1000) {
        return [NSString stringWithFormat:@"%i%@", posts, postCount[count]];
    }
    
    count++;
    return [self abbreviatePostCount:(posts / 1000) count:count];
        
}

@end
