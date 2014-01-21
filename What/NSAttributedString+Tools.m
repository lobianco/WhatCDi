//
//  NSAttributedString+Tools.m
//  What
//
//  Created by What on 7/22/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NSAttributedString+Tools.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Tools)

- (NSAttributedString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)set
{
    NSCharacterSet *invertedSet = set.invertedSet;
    NSString *string = self.string;
    
    if ([string rangeOfCharacterFromSet:invertedSet].location == NSNotFound)
        return [[NSAttributedString alloc] init];
    
    unsigned loc, len;
    
    NSRange range = [string rangeOfCharacterFromSet:invertedSet];
    loc = (range.length > 0) ? range.location : 0;
    
    range = [string rangeOfCharacterFromSet:invertedSet options:NSBackwardsSearch];
    len = (range.length > 0) ? NSMaxRange(range) - loc : string.length - loc;
    
    return [self attributedSubstringFromRange:NSMakeRange(loc, len)];
}

- (CGFloat)heightForAttributedStringWithFixedWidth:(CGFloat)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

-(NSAttributedString *)substringToIndex:(NSUInteger)index
{
    return [self attributedSubstringFromRange:NSMakeRange(0, index)];
}

@end
