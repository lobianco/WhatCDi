//
//  NSAttributedString+Tools.h
//  What
//
//  Created by What on 7/22/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Tools)

- (NSAttributedString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)set;
- (CGFloat)heightForAttributedStringWithFixedWidth:(CGFloat)width;
- (NSAttributedString *)substringToIndex:(NSUInteger)index;

@end
