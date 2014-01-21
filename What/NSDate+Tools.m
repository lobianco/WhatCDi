//
//  NSDate+Tools.m
//  What
//
//  Created by What on 6/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

+(NSString *)relativeDateFromNow {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    return [formatter stringFromDate:now];
}

+(NSString *)relativeDateFromDateString:(NSString *)dateString {
    NSDate *newDate = [self dateFromDateString:dateString];
    return [self relativeDateFromDate:newDate];
}

+(NSString *)relativeDateFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    const int DAY = 24 * HOUR;
    const int MONTH = 30 * DAY;
    const int YEAR = 12 * MONTH;
    
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [date timeIntervalSinceDate:now] * -1.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger units = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    NSDateComponents *components = [calendar components:units fromDate:date toDate:now options:0];
    
    if (delta < 0) {
        return @"From the future?";
        
    } else if (delta < 2 * MINUTE) {
        return @"just now";
        
    } else if (delta < 45 * MINUTE) {
        return [NSString stringWithFormat:@"%d minutes ago",components.minute];
        
    } else if (delta < 90 * MINUTE) {
        return @"an hour ago";
        
    } else if (delta < 24 * HOUR) {
        return (components.hour <= 1) ? @"one hour ago" : [NSString stringWithFormat:@"%d hours ago",components.hour];
        
    } else if (delta < 48 * HOUR) {
        return @"yesterday";
        
    } else if (delta < 30 * DAY) {
        return [NSString stringWithFormat:@"%d days ago",components.day];
        
    } else if (delta < 12 * MONTH) {
        return (components.month <= 1) ? @"one month ago" : [NSString stringWithFormat:@"%d months ago",components.month];
        
    } else if (delta < 10 * YEAR) {
        return (components.year <= 1) ? @"one year ago" : [NSString stringWithFormat:@"%d years ago", components.year];
        
    } else {
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        return [dateFormatter stringFromDate:date];        
    }
}

+(NSString *)monthFromDateString:(NSString *)dateString
{
    NSDate *newDate = [self dateFromDateString:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    
    return [dateFormatter stringFromDate:newDate];
}

+(NSString *)yearFromDateString:(NSString *)dateString
{
    NSDate *newDate = [self dateFromDateString:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    return [dateFormatter stringFromDate:newDate];
}

+(NSString *)timeFromDateString:(NSString *)dateString
{
    NSDate *newDate = [self dateFromDateString:dateString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm aa"];
    
    return [dateFormatter stringFromDate:newDate];
}

+(NSDate *)dateFromDateString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    });
    
    return [dateFormatter dateFromString:dateString];
}

@end
